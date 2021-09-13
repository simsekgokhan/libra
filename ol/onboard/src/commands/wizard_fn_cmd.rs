//! `version` subcommand

#![allow(clippy::never_loop)]

use abscissa_core::{Command, Options, Runnable, status_info, status_ok};
use diem_genesis_tool::ol_node_files;
use diem_types::waypoint::Waypoint;
use std::{path::PathBuf};
use super::{files_cmd};
use crate::{application::app_config};
/// `fullnode-wizard` subcommand
#[derive(Command, Debug, Default, Options)]
pub struct FnWizardCmd {
    #[options(help = "output path files created, defaults to ~/.0L")]
    path: Option<PathBuf>,
    #[options(help = "id of the chain")]
    chain_id: Option<u8>,
    #[options(help = "github org of genesis repo")]
    github_org: Option<String>,
    #[options(help = "repo with with genesis transactions")]
    repo: Option<String>,   
    #[options(help = "use a genesis file instead of building")]
    prebuilt_genesis: Option<PathBuf>,
    #[options(help = "skip fetching genesis blob")]
    skip_fetch_genesis: bool,
    #[options(help = "optional waypoint")]
    waypoint: Option<Waypoint>,
}

impl Runnable for FnWizardCmd {
    /// Print version message
    fn run(&self) {

        status_info!("\nFullnode Config Wizard", "This tool will create a fullnode.node.yaml file which is needed for the node to initialize and begin syncing. Different than validator configuration, no credentials are needed to operate a public fullnode.\n");
        let cfg = app_config().clone();

        let output_path = if self.path.is_some() {
            self.path.clone().unwrap()
        } else {
            cfg.clone().workspace.node_home
        };

        // TODO: fetch epoch backup info from epoch archive, or build genesis.
        if !self.skip_fetch_genesis {
            files_cmd::get_files(
                output_path,
                &self.github_org,
                &self.repo,
            );
            status_ok!("\nGenesis OK", "\n...........................\n");
        }

        let home_dir = cfg.workspace.node_home.to_owned();
        // 0L convention is for the namespace of the operator to be appended by '-oper'
        let namespace = cfg.profile.auth_key.clone() + "-oper";
        
        ol_node_files::write_node_config_files(
            home_dir.clone(),
            self.chain_id.unwrap_or(1),
            &self.github_org.clone().unwrap_or("OLSF".to_string()),
            &self
                .repo
                .clone()
                .unwrap_or("experimental-genesis".to_string()),
            &namespace,
            &self.prebuilt_genesis,
            &true,
            self.waypoint,
        ).unwrap();
        status_ok!("\nNode config OK", "\n...........................\n");
    }
}
