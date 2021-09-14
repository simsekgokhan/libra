// ALICE is CASE 1
//! account: alice, 1000000GAS, 0, validator

// BOB is CASE 4
//! account: bob, 1000000GAS, 0, validator

// CAROL is CASE 1 AS WELL
//! account: carol, 1000000GAS, 0, validator

// DAVE is CASE 4
//! account: dave, 1000000GAS, 0, validator

//! new-transaction
//! sender: alice
script {
    use 0x1::MinerState;
    fun main(sender: signer) {
      //NOTE: Alice is Case 1, she validates and mines. Setting up mining.
        let mining_proofs = 5;
        MinerState::test_helper_mock_mining(&sender, mining_proofs);
    }
}
//check: EXECUTED


//! new-transaction
//! sender: carol
script {
    use 0x1::MinerState;
    fun main(sender: signer) {
      //NOTE: Carol is Case 3, she mines but does not validate. Setting up mining.
      let mining_proofs = 5;
      MinerState::test_helper_mock_mining(&sender, mining_proofs);

    }
}
//check: EXECUTED

//! new-transaction
//! sender: diemroot
script {
  use 0x1::Vector;
  use 0x1::Stats;
  use 0x1::GAS::GAS;
  use 0x1::DiemAccount;
  use 0x1::Cases;

  fun main(vm: signer) {
    // check the case of a network density of 4 active validators.

    let vm = &vm;
    let validators = Vector::singleton<address>(@{{alice}});
    Vector::push_back(&mut validators, @{{carol}});

    // create mock validator stats for full epoch
    let i = 0;
    while (i < 16) {
      Stats::process_set_votes(vm, &validators);
      i = i + 1;
    };

    assert(DiemAccount::balance<GAS>(@{{alice}}) == 1000000, 7357190102011000);
    assert(DiemAccount::balance<GAS>(@{{bob}}) == 1000000, 7357190102021000);
    assert(DiemAccount::balance<GAS>(@{{carol}}) == 1000000, 7357190102031000);
    assert(DiemAccount::balance<GAS>(@{{dave}}) == 1000000, 7357190102041000);

    assert(Cases::get_case(vm, @{{alice}}, 0, 15) == 1, 7357190102051000);
    assert(Cases::get_case(vm, @{{bob}}, 0, 15) == 4, 7357190102061000);
    assert(Cases::get_case(vm, @{{carol}}, 0, 15) == 1, 7357190102071000);
    assert(Cases::get_case(vm, @{{dave}}, 0, 15) == 4, 7357190102081000);
  }
}
// check: EXECUTED


//! new-transaction
//! sender: diemroot
script {
  use 0x1::Subsidy;
  use 0x1::GAS::GAS;
  use 0x1::DiemAccount;
  use 0x1::DiemSystem;

  fun main(vm: signer) {
    let (validators, fee_ratios) = DiemSystem::get_fee_ratio(&vm, 0, 15);
    let subsidy_amount = 1000000;
    // from Subsidy::BASELINE_TX_COST * genesis five submitted (mock)
    let mining_proofs = 5;
    let refund_to_operator = 4336 * mining_proofs;  
    Subsidy::process_subsidy(&vm, subsidy_amount, &validators, &fee_ratios);
    assert(
      DiemAccount::balance<GAS>(@{{alice}}) == 1000000 + subsidy_amount/2 - refund_to_operator, 
      7357190102091000
    );

    assert(DiemAccount::balance<GAS>(@{{bob}}) == 1000000, 7357190102101000);
    assert(
      DiemAccount::balance<GAS>(@{{carol}}) == 1000000 + subsidy_amount/2 - refund_to_operator,
      7357190102111000
    );
    assert(DiemAccount::balance<GAS>(@{{dave}}) == 1000000, 7357190102121000);
  }
}
// check: EXECUTED
