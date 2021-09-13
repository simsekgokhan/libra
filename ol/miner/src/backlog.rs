//! Miner resubmit backlog transactions module
#![forbid(unsafe_code)]

use abscissa_core::status_info;
use cli::{diem_client::DiemClient};
use ol_types::block::Block;
use txs::submit_tx::{TxParams, eval_tx_status};
use std::{fs::File, path::PathBuf};
use ol_types::config::AppCfg;
use crate::commit_proof::commit_proof_tx;
use std::io::BufReader;
use crate::block::parse_block_height;
use anyhow::{bail, Result, Error};
use diem_json_rpc_types::views::{MinerStateResourceView};

/// Submit a backlog of blocks that may have been mined while network is offline. 
/// Likely not more than 1. 
pub fn process_backlog(
    config: &AppCfg, tx_params: &TxParams, is_operator: bool
) -> Result<(), Error> {
    // Getting remote miner state
    let remote_state = get_remote_state(tx_params)?;
    let remote_height = remote_state.verified_tower_height;

    println!("Remote tower height: {}", remote_height);
    // Getting local state height
    let mut blocks_dir = config.workspace.node_home.clone();
    blocks_dir.push(&config.workspace.block_dir);
    let (current_block_number, _current_block_path) = parse_block_height(&blocks_dir);
    if let Some(current_block_number) = current_block_number {
        println!("Local tower height: {:?}", current_block_number);
        if current_block_number > remote_height { 
            status_info!("Backlog:","resubmitting missing blocks.");

            let mut i = remote_height + 1;
            while i <= current_block_number {
                let path = PathBuf::from(
                    format!("{}/block_{}.json", blocks_dir.display(), i)
                );
                let file = File::open(&path)?;
                let reader = BufReader::new(file);
                let block: Block = serde_json::from_reader(reader)?;
                let view = commit_proof_tx(
                    &tx_params, block.preimage, block.proof, is_operator
                )?;
                eval_tx_status(view)?;
                i = i + 1;
            }
        }
    }
    Ok(())
}

/// returns remote node state given tx_params
pub fn get_remote_state(tx_params: &TxParams) -> Result<MinerStateResourceView, Error> {
    let client = DiemClient::new(tx_params.url.clone(), tx_params.waypoint).unwrap();
    println!("Fetching remote tower height: {}, {}", 
        tx_params.url.clone(), tx_params.owner_address.clone()
    );
    let remote_state = client.get_miner_state(&tx_params.owner_address);
    match remote_state {
        Ok( s ) => { match s {
            Some(state) => {
                Ok(state)
            },
            None => {
                println!("Info: Received response but no remote state found. Exiting.");
                bail!("Info: Received response but no remote state found. Exiting.")
            }
        } },
        Err(e) => {
            println!("Error fetching remote state: {:?}", e);
            bail!("Error fetching remote state: {:?}", e)
        },
    }
}