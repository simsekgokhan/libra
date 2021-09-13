//! `OracleUpgrade` subcommand

#![allow(clippy::never_loop)]

use abscissa_core::{Command, Options, Runnable};
use ol_types::config::TxType;
use crate::{entrypoint, prelude::app_config, submit_tx::{tx_params_wrapper, maybe_submit}};
use diem_types::transaction::TransactionPayload;
use diem_transaction_builder::stdlib as transaction_builder;
use std::{fs, io::prelude::*, path::PathBuf, process::exit};

/// `OracleUpgrade` subcommand
#[derive(Command, Debug, Default, Options)]
pub struct OracleUpgradeCmd {
    #[options(short = "f", help = "Path of upgrade file")]
    upgrade_file_path: Option<PathBuf>,
}

pub fn oracle_tx_script(upgrade_file_path: &PathBuf) -> TransactionPayload {
    let mut file = fs::File::open(upgrade_file_path)
        .expect("file should open read only");
    let mut buffer = Vec::new();
    file.read_to_end(&mut buffer).expect("failed to read the file");

    let id = 1; // upgrade is oracle #1
    transaction_builder::encode_ol_oracle_tx_script_function(id, buffer)
}

impl Runnable for OracleUpgradeCmd {
    fn run(&self) {  
        let entry_args = entrypoint::get_args();
        let tx_params = tx_params_wrapper(TxType::Critical).unwrap();

        let path = self.upgrade_file_path.clone().unwrap_or_else(|| {
          let cfg = app_config();
          match cfg.workspace.stdlib_bin_path.clone() {
            Some(p) => p,
            None => {
              println!(
                "could not find path to compiled stdlib.mv, was this set in 0L.toml? \
                 Alternatively pass the full path with: \
                 -f <project_root>/language/stdlib/staged/stdlib.mv"
              );
              exit(1);
            },
          }
        });
        
        match maybe_submit(
          oracle_tx_script(&path),
          &tx_params,
          entry_args.no_send,
          entry_args.save_path
        ) {
            Err(e) => {
              println!("ERROR: could not submit upgrade transaction, message: \n{:?}", &e);
              exit(1);
            },
            _ => {}
        }
    }
}
