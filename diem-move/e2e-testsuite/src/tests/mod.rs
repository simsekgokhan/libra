// Copyright (c) The Diem Core Contributors
// SPDX-License-Identifier: Apache-2.0

//! Test module.
//!
//! Add new test modules to this list.
//!
//! This is not in a top-level tests directory because each file there gets compiled into a
//! separate binary. The linker ends up repeating a lot of work for each binary to not much
//! benefit.

mod account_limits;
mod account_universe;
mod admin_script;
mod create_account;
mod crsn;
mod data_store;
mod emergency_admin_script;
mod execution_strategies;
mod experimental;
mod failed_transaction_tests;
mod genesis;
mod genesis_initializations;
mod mint;
mod module_publishing;
mod multi_agent;
mod on_chain_configs;
mod parallel_execution;
mod peer_to_peer;
mod preburn_queue;
mod rotate_key;
mod script_functions;
mod scripts;
mod transaction_builder;
mod transaction_fees;
mod transaction_fuzzer;
mod validator_set_management;
mod vasps;
mod verify_txn;
mod write_set;
mod writeset_builder;

//////// 0L ////////
mod ol_reconfig;
mod ol_upgrade_oracle;
mod ol_minerstate_commit;
mod ol_demo;
mod ol_autopay_enable;
mod ol_autopay_create;