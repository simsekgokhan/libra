// Copyright (c) The Diem Core Contributors
// SPDX-License-Identifier: Apache-2.0

pub mod errors;
pub mod request;
pub mod response;
pub mod views;

use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, Debug, Deserialize, Serialize)]
enum JsonRpcVersion {
    #[serde(rename = "2.0")]
    V2,
}

#[derive(Clone, Debug, Eq, PartialEq, Ord, PartialOrd, Hash, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
#[serde(untagged)]
pub enum Id {
    /// Numeric id
    Number(u64),
    /// String id
    String(Box<str>),
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Hash, Deserialize, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum Method {
    Submit,
    GetMetadata,
    GetAccount,
    GetTransactions,
    GetAccountTransaction,
    GetAccountTransactions,
    GetEvents,
    GetCurrencies,
    GetNetworkStatus,

    //
    // Experimental APIs
    //
    GetStateProof,
    GetAccountStateWithProof,
    GetTransactionsWithProofs,
    GetEventsWithProofs,

    //////// 0L ////////
    GetMinerStateView,
    GetOracleUpgradeStateView,
}

impl Method {
    pub fn as_str(&self) -> &str {
        match self {
            Method::Submit => "submit",
            Method::GetMetadata => "get_metadata",
            Method::GetAccount => "get_account",
            Method::GetTransactions => "get_transactions",
            Method::GetAccountTransaction => "get_account_transaction",
            Method::GetAccountTransactions => "get_account_transactions",
            Method::GetEvents => "get_events",
            Method::GetCurrencies => "get_currencies",
            Method::GetNetworkStatus => "get_network_status",
            Method::GetStateProof => "get_state_proof",
            Method::GetAccountStateWithProof => "get_account_state_with_proof",
            Method::GetTransactionsWithProofs => "get_transactions_with_proofs",
            Method::GetEventsWithProofs => "get_events_with_proofs",

            //////// 0L ////////
            Method::GetMinerStateView => "get_miner_state_view", // Name is not used in json RPC, only for errors, what matters is the type name, which serde formats as snakecase.
            
            Method::GetOracleUpgradeStateView => "get_oracle_upgrade_state_view", 
        }
    }
}
