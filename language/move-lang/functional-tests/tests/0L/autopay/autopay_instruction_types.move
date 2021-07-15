//! account: bob, 10000GAS, 0, validator
//! account: alice, 10000GAS, 0
//! account: jim, 10000GAS, 0
//! account: lucy, 10000GAS, 0 
//! account: paul, 10000GAS, 0 
//! account: thomas, 10000GAS, 0
//! account: denice, 10000GAS, 0
//! account: carlos, 10000GAS, 0
//! account: eric, 10000GAS, 0 

// test runs various autopay instruction types to ensure they are being executed as expected
//! new-transaction
module Holder {
    struct Hold has key { x: u64 }
    public fun hold(account: &signer, x: u64) {
        move_to(account, Hold{ x })
    }

    public fun fetch(addr: address): u64 acquires Hold {
      borrow_global<Hold>(addr).x
    }
}

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
use 0x1::DiemAccount;
use {{default}}::Holder;
  fun main(lr: signer, alice_account: signer) {
      AccountLimits::publish_unrestricted_limits<GAS>(&alice_account);
      AccountLimits::update_limits_definition<GAS>(&lr, {{alice}}, 0, 10000, 0, 1);
      AccountLimits::publish_window<GAS>(&lr, &alice_account, {{alice}});
    Holder::hold(&alice_account, DiemAccount::balance<GAS>({{alice}}));
  }
}
// check: "Keep(EXECUTED)"

//! new-transaction
//! sender: diemroot
//! execute-as: jim
script {
use 0x1::AccountLimits;
use 0x1::GAS::GAS;
use 0x1::DiemAccount;
use {{default}}::Holder;
  fun main(lr: signer, jim_account: signer) {
      AccountLimits::publish_unrestricted_limits<GAS>(&jim_account);
      AccountLimits::update_limits_definition<GAS>(&lr, {{jim}}, 0, 10000, 0, 1);
      AccountLimits::publish_window<GAS>(&lr, &jim_account, {{jim}});
    Holder::hold(&jim_account, DiemAccount::balance<GAS>({{jim}}));
  }
}
// check: "Keep(EXECUTED)"

//! new-transaction
//! sender: diemroot
//! execute-as: lucy
script {
use 0x1::AccountLimits;
use 0x1::GAS::GAS;
use 0x1::DiemAccount;
use {{default}}::Holder;
  fun main(lr: signer, lucy_account: signer) {
      AccountLimits::publish_unrestricted_limits<GAS>(&lucy_account);
      AccountLimits::update_limits_definition<GAS>(&lr, {{lucy}}, 0, 10000, 0, 1);
      AccountLimits::publish_window<GAS>(&lr, &lucy_account, {{lucy}});
    Holder::hold(&lucy_account, DiemAccount::balance<GAS>({{lucy}}));
  }
}
// check: "Keep(EXECUTED)"

//! new-transaction
//! sender: diemroot
//! execute-as: paul
script {
use 0x1::AccountLimits;
use 0x1::GAS::GAS;
use 0x1::DiemAccount;
use {{default}}::Holder;
  fun main(lr: signer, paul_account: signer) {
      AccountLimits::publish_unrestricted_limits<GAS>(&paul_account);
      AccountLimits::update_limits_definition<GAS>(&lr, {{paul}}, 0, 10000, 0, 1);
      AccountLimits::publish_window<GAS>(&lr, &paul_account, {{paul}});
    Holder::hold(&paul_account, DiemAccount::balance<GAS>({{paul}}));
  }
}
// check: "Keep(EXECUTED)"

//! new-transaction
//! sender: diemroot
//! execute-as: thomas
script {
use 0x1::AccountLimits;
use 0x1::GAS::GAS;
use 0x1::DiemAccount;
use {{default}}::Holder;
  fun main(lr: signer, thomas_account: signer) {
      AccountLimits::publish_unrestricted_limits<GAS>(&thomas_account);
      AccountLimits::update_limits_definition<GAS>(&lr, {{thomas}}, 0, 10000, 0, 1);
      AccountLimits::publish_window<GAS>(&lr, &thomas_account, {{thomas}});
    Holder::hold(&thomas_account, DiemAccount::balance<GAS>({{thomas}}));
  }
}
// check: "Keep(EXECUTED)"

//! new-transaction
//! sender: diemroot
//! execute-as: denice
script {
use 0x1::AccountLimits;
use 0x1::GAS::GAS;
use 0x1::DiemAccount;
use {{default}}::Holder;
  fun main(lr: signer, denice_account: signer) {
      AccountLimits::publish_unrestricted_limits<GAS>(&denice_account);
      AccountLimits::update_limits_definition<GAS>(&lr, {{denice}}, 0, 10000, 0, 1);
      AccountLimits::publish_window<GAS>(&lr, &denice_account, {{denice}});
    Holder::hold(&denice_account, DiemAccount::balance<GAS>({{denice}}));
  }
}
// check: "Keep(EXECUTED)"

//! new-transaction
//! sender: diemroot
//! execute-as: carlos
script {
use 0x1::AccountLimits;
use 0x1::GAS::GAS;
use 0x1::DiemAccount;
use {{default}}::Holder;
  fun main(lr: signer, carlos_account: signer) {
      AccountLimits::publish_unrestricted_limits<GAS>(&carlos_account);
      AccountLimits::update_limits_definition<GAS>(&lr, {{carlos}}, 0, 10000, 0, 1);
      AccountLimits::publish_window<GAS>(&lr, &carlos_account, {{carlos}});
    Holder::hold(&carlos_account, DiemAccount::balance<GAS>({{carlos}}));
  }
}
// check: "Keep(EXECUTED)"

//! new-transaction
//! sender: diemroot
//! execute-as: eric
script {
use 0x1::AccountLimits;
use 0x1::GAS::GAS;
use 0x1::DiemAccount;
use {{default}}::Holder;
  fun main(lr: signer, eric_account: signer) {
      AccountLimits::publish_unrestricted_limits<GAS>(&eric_account);
      AccountLimits::update_limits_definition<GAS>(&lr, {{eric}}, 0, 10000, 0, 1);
      AccountLimits::publish_window<GAS>(&lr, &eric_account, {{eric}});
    Holder::hold(&eric_account, DiemAccount::balance<GAS>({{eric}}));
  }
}
// check: "Keep(EXECUTED)"


// alice commits to paying jim 5% of her worth per epoch
//! new-transaction
//! sender: alice
script {
  use 0x1::AutoPay2;
  use 0x1::Signer;
  fun main(sender: signer) {
    let sender = &sender;
    AutoPay2::enable_autopay(sender);
    assert(AutoPay2::is_enabled(Signer::address_of(sender)), 0);
    
    AutoPay2::create_instruction(sender, 1, 0, {{jim}}, 2, 500);

    let (type, payee, end_epoch, percentage) = AutoPay2::query_instruction(
        Signer::address_of(sender), 1
    );
    assert(type == 0, 1);
    assert(payee == {{jim}}, 1);
    assert(end_epoch == 2, 1);
    assert(percentage == 500, 1);
  }
}
// check: EXECUTED

// lucy commits to paying paul 5% of her inflow each epoch
//! new-transaction
//! sender: lucy
script {
  use 0x1::AutoPay2;
  use 0x1::Signer;
  fun main(sender: signer) {
    let sender = &sender;
    AutoPay2::enable_autopay(sender);
    assert(AutoPay2::is_enabled(Signer::address_of(sender)), 0);
    
    AutoPay2::create_instruction(sender, 1, 1, {{paul}}, 2, 500);

    let (type, payee, end_epoch, percentage) = AutoPay2::query_instruction(
        Signer::address_of(sender), 1
    );
    assert(type == 1, 1);
    assert(payee == {{paul}}, 1);
    assert(end_epoch == 2, 1);
    assert(percentage == 500, 1);
  }
}
// check: EXECUTED

// thomas commits to paying denice 200 GAS per epoch
//! new-transaction
//! sender: thomas
script {
  use 0x1::AutoPay2;
  use 0x1::Signer;
  fun main(sender: signer) {
    let sender = &sender;
    AutoPay2::enable_autopay(sender);
    assert(AutoPay2::is_enabled(Signer::address_of(sender)), 0);
    
    AutoPay2::create_instruction(sender, 1, 2, {{denice}}, 2, 200);

    let (type, payee, end_epoch, percentage) = AutoPay2::query_instruction(
        Signer::address_of(sender), 1
    );
    assert(type == 2, 1);
    assert(payee == {{denice}}, 1);
    assert(end_epoch == 2, 1);
    assert(percentage == 200, 1);
  }
}
// check: EXECUTED

// carlos commits to paying eric 500 GAS at the next tick
//! new-transaction
//! sender: carlos
script {
  use 0x1::AutoPay2;
  use 0x1::Signer;
  fun main(sender: signer) {
    let sender = &sender;
    AutoPay2::enable_autopay(sender);
    assert(AutoPay2::is_enabled(Signer::address_of(sender)), 0);
    
    // note: end epoch does not matter here as long as it is after the next epoch
    AutoPay2::create_instruction(sender, 1, 3, {{eric}}, 200, 500);

    let (type, payee, end_epoch, percentage) = AutoPay2::query_instruction(
        Signer::address_of(sender), 1
    );
    assert(type == 3, 1);
    assert(payee == {{eric}}, 1);
    assert(end_epoch == 200, 1);
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
  use 0x1::AutoPay2;
  use 0x1::DiemAccount;
  use 0x1::GAS::GAS;
  use 0x1::Diem;
  use {{default}}::Holder;
  use 0x1::FixedPoint32;
  fun main(vm: signer) {
    let alice_store = Holder::fetch({{alice}});
    let lucy_store = Holder::fetch({{lucy}});
    let thomas_store = Holder::fetch({{thomas}});
    let carlos_store = Holder::fetch({{carlos}});
    

    let ending_balance = DiemAccount::balance<GAS>({{alice}});
    let amount_sent = FixedPoint32::multiply_u64(alice_store, FixedPoint32::create_from_rational(500, 10000));
    assert(alice_store - ending_balance == amount_sent, 7357004);
    assert(alice_store - ending_balance >0, 7357004);

    // lucy didn't receive any funds, so no change in balance, so no payment sent
    let ending_balance = DiemAccount::balance<GAS>({{lucy}});
    assert(lucy_store - ending_balance == 0, 7357006);

    let ending_balance = DiemAccount::balance<GAS>({{thomas}});
    assert(thomas_store - ending_balance == 200, 7357006);

    let ending_balance = DiemAccount::balance<GAS>({{carlos}});
    assert(carlos_store - ending_balance == 500, 7357006);
    //Confirm the one-shot instruction was deleted
    let (type, payee, end_epoch, percentage) = AutoPay2::query_instruction({{carlos}}, 1);
    assert(type == 0, 1);
    assert(payee == 0x0, 1);
    assert(end_epoch == 0, 1);
    assert(percentage == 0, 1);

    let coin = Diem::mint<GAS>(&vm, 10000);
    assert(Diem::value<GAS>(&coin) == 10000, 1);
    DiemAccount::vm_deposit_with_metadata<GAS>(
        &vm,
        {{lucy}},
        coin,
        x"", x""
    );

    let ending_balance = DiemAccount::balance<GAS>({{lucy}});
    assert(ending_balance - lucy_store == 10000, 7357006);
    
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
  use 0x1::AutoPay2;
  use {{default}}::Holder;
  use 0x1::FixedPoint32;
  fun main(_vm: signer) {
    let alice_store = Holder::fetch({{alice}});
    let lucy_store = Holder::fetch({{lucy}});
    let thomas_store = Holder::fetch({{thomas}});
    let carlos_store = Holder::fetch({{carlos}});
    let jim_store = Holder::fetch({{jim}});
    let paul_store = Holder::fetch({{paul}});
    let denice_store = Holder::fetch({{denice}});
    let eric_store = Holder::fetch({{eric}});

    let ending_balance = DiemAccount::balance<GAS>({{alice}});
    let amount_sent = FixedPoint32::multiply_u64(alice_store, FixedPoint32::create_from_rational(500, 10000));
    let second_bal = alice_store - amount_sent;
    amount_sent = amount_sent + FixedPoint32::multiply_u64(second_bal, FixedPoint32::create_from_rational(500, 10000));
    assert(alice_store - ending_balance == amount_sent, 7357004);

    // lucy will have paid 5% on the 10000 she received last epoch
    let ending_balance = DiemAccount::balance<GAS>({{lucy}});
    assert(ending_balance - lucy_store == 9501, 7357006);
    
    let ending_balance = DiemAccount::balance<GAS>({{thomas}});
    assert(thomas_store - ending_balance == 400, 7357006);

    // no change, one-shot instruction is finished
    let ending_balance = DiemAccount::balance<GAS>({{carlos}});
    assert(carlos_store - ending_balance == 500, 7357006);

    // check balance of recipients
    let ending_balance = DiemAccount::balance<GAS>({{jim}});
    assert(ending_balance - jim_store == amount_sent, 7357006);

    let ending_balance = DiemAccount::balance<GAS>({{paul}});
    assert(ending_balance - paul_store == 499, 7357006);

    let ending_balance = DiemAccount::balance<GAS>({{denice}});
    assert(ending_balance - denice_store == 400, 7357006);

    let ending_balance = DiemAccount::balance<GAS>({{eric}});
    assert(ending_balance - eric_store == 500, 7357006);

    //all instructions should be deleted as they expired in epoch 2, check to confirm
    //Confirm the one-shot instruction was deleted
    let (type, payee, end_epoch, percentage) = AutoPay2::query_instruction({{alice}}, 1);
    assert(type == 0, 1);
    assert(payee == 0x0, 1);
    assert(end_epoch == 0, 1);
    assert(percentage == 0, 1);

    let (type, payee, end_epoch, percentage) = AutoPay2::query_instruction({{lucy}}, 1);
    assert(type == 0, 1);
    assert(payee == 0x0, 1);
    assert(end_epoch == 0, 1);
    assert(percentage == 0, 1);

    let (type, payee, end_epoch, percentage) = AutoPay2::query_instruction({{thomas}}, 1);
    assert(type == 0, 1);
    assert(payee == 0x0, 1);
    assert(end_epoch == 0, 1);
    assert(percentage == 0, 1);
  }


}
// check: EXECUTED
