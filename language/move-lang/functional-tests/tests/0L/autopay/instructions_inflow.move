// Todo: These GAS values have no effect, all accounts start with 1M GAS
//! account: bob,   1000000GAS, 0, validator
//! account: alice, 1000000GAS, 0 
//! account: carol, 1000000GAS, 0 

// test runs various autopay instruction types to ensure they are being executed as expected

//! new-transaction
//! sender: carol
script {
  use 0x1::Wallet;
  use 0x1::Vector;

  fun main(sender: signer) {
    Wallet::set_comm(&sender);
    let list = Wallet::get_comm_list();
    assert(Vector::length(&list) == 1, 7357001);
  }
}

// check: EXECUTED

//! new-transaction
//! sender: diemroot
script {
  use 0x1::AccountLimits;
  use 0x1::CoreAddresses;
  use 0x1::GAS::GAS;
  fun main(account: signer) {
    AccountLimits::update_limits_definition<GAS>(
      &account, CoreAddresses::DIEM_ROOT_ADDRESS(), 0, 10000, 0, 1
    );
  }
}
// check: "Keep(EXECUTED)"

//! new-transaction
//! sender: diemroot
//! execute-as: alice
script {
use 0x1::AccountLimits;
use 0x1::GAS::GAS;
  fun main(dm: signer, alice_account: signer) {
    AccountLimits::publish_unrestricted_limits<GAS>(&alice_account);
    AccountLimits::update_limits_definition<GAS>(&dm, @{{alice}}, 0, 10000, 0, 1);
    AccountLimits::publish_window<GAS>(&dm, &alice_account, @{{alice}});
  }
}
// check: "Keep(EXECUTED)"

// alice commits to paying carol 5% of her inflow each epoch
//! new-transaction
//! sender: alice
script {
  use 0x1::AutoPay2;
  use 0x1::Signer;
  fun main(sender: signer) {
    let sender = &sender;
    AutoPay2::enable_autopay(sender);
    assert(AutoPay2::is_enabled(Signer::address_of(sender)), 0);
    
    AutoPay2::create_instruction(sender, 1, 1, @{{carol}}, 2, 500);

    let (type, payee, end_epoch, percentage) = AutoPay2::query_instruction(
      Signer::address_of(sender), 1
    );
    assert(type == 1, 1);
    assert(payee == @{{carol}}, 1);
    assert(end_epoch == 2, 1);
    assert(percentage == 500, 1);
  }
}
// check: EXECUTED


///////////////////////////////////////////////////
///// Trigger Autopay Tick at 31 secs           ////
/// i.e. 1 second after 1/2 epoch  /////
//! block-prologue
//! proposer: bob
//! block-time: 31000000
//! round: 23
///////////////////////////////////////////////////


// Weird. This next block needs to be added here otherwise the prologue above does not run.
///////////////////////////////////////////////////
///// Trigger Autopay Tick at 31 secs           ////
/// i.e. 1 second after 1/2 epoch  /////
//! block-prologue
//! proposer: bob
//! block-time: 32000000
//! round: 24
///////////////////////////////////////////////////

//! new-transaction
//! sender: diemroot
script {
  use 0x1::DiemAccount;
  use 0x1::GAS::GAS;
  use 0x1::Diem;
  fun main(vm: signer) {
    // alice didn't receive any funds, so no change in balance, so no payment sent
    let ending_balance = DiemAccount::balance<GAS>(@{{alice}});
    assert(ending_balance == 1000000, 7357002);

    // add funds to alice account for next tick
    let coin = Diem::mint<GAS>(&vm, 10000);
    assert(Diem::value<GAS>(&coin) == 10000, 1);
    DiemAccount::vm_deposit_with_metadata<GAS>(
        &vm,
        @{{alice}},
        coin,
        x"", x""
    );

    let ending_balance = DiemAccount::balance<GAS>(@{{alice}});
    assert(ending_balance == 1010000, 7357003);
  }
}
// check: EXECUTED

///////////////////////////////////////////////////
///// Trigger Autopay Tick at 31 secs           ////
/// i.e. 1 second after 1/2 epoch  /////
//! block-prologue
//! proposer: bob
//! block-time: 61000000
//! round: 65
///////////////////////////////////////////////////

///////////////////////////////////////////////////
///// Trigger Autopay Tick at 31 secs           ////
/// i.e. 1 second after 1/2 epoch  /////
//! block-prologue
//! proposer: bob
//! block-time: 92000000
//! round: 66
///////////////////////////////////////////////////
///////////////////////////////////////////////////
///// Trigger Autopay Tick at 31 secs           ////
/// i.e. 1 second after 1/2 epoch  /////
//! block-prologue
//! proposer: bob
//! block-time: 93000000
//! round: 67
///////////////////////////////////////////////////

//! new-transaction
//! sender: diemroot
script {
  use 0x1::DiemAccount;
  use 0x1::GAS::GAS;
  // use 0x1::Debug::print;
  fun main(_vm: signer) {
    // alice will have paid 5% on the 10000 she received last epoch
    let ending_balance = DiemAccount::balance<GAS>(@{{alice}});
    // print(&ending_balance);
    assert(ending_balance == 1009501, 7357004);

    // check balance of recipients
    let ending_balance = DiemAccount::balance<GAS>(@{{carol}});
    // print(&ending_balance);
    assert(ending_balance == 1000499, 7357005);
  }
}
// check: EXECUTED