// Copyright (c) 0lsf
// SPDX-License-Identifier: Apache-2.0

use diem_transaction_builder::stdlib as transaction_builder;
use diem_types::{transaction::TransactionStatus, vm_status::KeptVMStatus};
use language_e2e_tests::{account::AccountData, executor::FakeExecutor};

#[test]
fn autopay_create_test() {
    let mut executor = FakeExecutor::from_genesis_file();

    let sender = AccountData::new(1_000_000, 1);
    let recipient = AccountData::new(1_000_000, 1);
    executor.add_account_data(&sender);
    executor.add_account_data(&recipient);

    let mut seq_num = 1;
    let payload = transaction_builder::encode_autopay_enable_script_function();
    let txn_enable = sender
        .clone()
        .into_account()
        .transaction()
        .payload(payload)
        .sequence_number(seq_num)
        .sign();

    // execute transaction
    let output = executor.execute_and_apply(txn_enable);
    assert_eq!(
        output.status(),
        &TransactionStatus::Keep(KeptVMStatus::Executed)
    );

    seq_num = 2;

    let payload = transaction_builder::encode_autopay_create_instruction_script_function(
        1,
        0,
        *recipient.address(),
        10,
        10,
    );

    let txn_create = sender
        .into_account()
        .transaction()
        .payload(payload)
        .sequence_number(seq_num)
        .sign();

    // execute transaction
    let output = executor.execute_transaction(txn_create);
    assert_eq!(
        output.status(),
        &TransactionStatus::Keep(KeptVMStatus::Executed)
    );
}
