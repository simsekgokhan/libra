//! `version` subcommand

#![allow(clippy::never_loop)]

use crate::{account, block::{build_block}, config::MinerConfig, delay};

use libra_genesis_tool::keyscheme::KeyScheme;

use abscissa_core::{Command, Options, Runnable};
use libra_wallet::WalletLibrary;
use std::path::PathBuf;
use crate::prelude::app_config;

/// `manifest` subcommand
#[derive(Command, Debug, Default, Options)]
pub struct ManifestCmd {
    #[options(help = "path to write account manifest")]
    path: Option<PathBuf>,
    #[options(help = "path to file to be checked")]
    check: bool,
    #[options(help = "regenerates account manifest from mnemonic")]
    fix: bool,
    #[options(help = "creates a validator account")]
    validator: bool,
    #[options(help = "use an existing block_0.json file and skip mining")]
    block_zero: Option<PathBuf>,
}

impl Runnable for ManifestCmd {
    /// Print version message
    fn run(&self) {
        // let miner_configs = app_config();
        let path = self.path.clone().unwrap_or_else(|| PathBuf::from("."));
        if self.check {
            check(path);
        } else {
            let (_, _, wallet) = keygen::account_from_prompt();

            write_manifest(&Some(path), wallet, None);
        }
    }
}
/// Creates an account.json file for the validator
pub fn write_manifest(path: &Option<PathBuf>, wallet: WalletLibrary, wizard_config: Option<MinerConfig> ) {
    let cfg = if wizard_config.is_some() { wizard_config.unwrap() }
    else { app_config().clone() };

    let miner_home = path
    .clone()
    .unwrap_or_else(|| cfg.workspace.node_home.clone()
    );

    let keys = KeyScheme::new(&wallet);
    let block = build_block::parse_block_file(cfg.get_block_dir().join("block_0.json").to_owned());

    account::ValConfigs::new(
        block,
        keys,  
        cfg.profile.ip.to_string()
    ).create_manifest(miner_home);
}

/// Checks the format of the account manifest, including vdf proof
fn check(path: PathBuf) {
    let user_data = account::UserConfigs::get_init_data(&path).expect(&format!("could not parse manifest in {:?}", &path));

    match delay::verify(&user_data.block_zero.preimage, &user_data.block_zero.proof) {
        true => println!("Proof verified in {:?}", &path),
        false => println!("Invalid proof in {:?}", &path)
    }
}
