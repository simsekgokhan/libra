// Copyright (c) The Diem Core Contributors
// SPDX-License-Identifier: Apache-2.0

#![forbid(unsafe_code)]

pub mod command;
mod genesis;
pub mod key;  //////// 0L /////////
pub mod waypoint;  //////// 0L /////////
pub mod layout;
mod validator_config;
mod validator_operator;
mod verify;

//////// 0L ////////
pub mod init;
pub mod ol_node_files;
mod ol_mining;
pub mod seeds;
pub mod ol_create_repo;

#[cfg(any(test, feature = "testing"))]
pub mod config_builder;
//////// 0L /////////
// #[cfg(any(test, feature = "testing"))]
// This was previously only for tests 0L uses for init key_store.json.
pub mod storage_helper;
#[cfg(any(test, feature = "testing"))]
pub mod swarm_config;

#[cfg(any(test, feature = "testing"))]
pub use crate::config_builder::test_config;
