// This test is to check if subsidy calculations are impacted by dummy node statistics.

// NOTE: We are creating 7 validators.
//! account: alice, 1000000, 0, validator
//! account: bob, 1000000, 0, validator
//! account: carol, 1000000, 0, validator
//! account: dave, 1000000, 0, validator
//! account: eve, 1000000, 0, validator
//! account: frank, 1000000, 0, validator
//! account: gene, 1000000, 0, validator


//! block-prologue
//! proposer: alice
//! block-time: 1

//! new-transaction
//! sender: diemroot
script {
  use 0x1::Subsidy;
  use 0x1::Vector;
  use 0x1::Stats;
  use 0x1::Debug::print;

  fun main(vm: signer) {
    // check the case of a network density of 7 active validators.

    let vm = &vm;
    let validators = Vector::singleton<address>(@{{alice}});
    Vector::push_back(&mut validators, @{{bob}});
    Vector::push_back(&mut validators, @{{carol}});
    Vector::push_back(&mut validators, @{{dave}});
    Vector::push_back(&mut validators, @{{eve}});
    Vector::push_back(&mut validators, @{{frank}});
    Vector::push_back(&mut validators, @{{gene}});

    // create mock validator stats for full epoch
    let i = 0;
    while (i < 16) {
      Stats::process_set_votes(vm, &validators);
      i = i + 1;
    };
    print(&Subsidy::calculate_subsidy(vm, 0, 15));
    assert(Subsidy::calculate_subsidy(vm, 0, 15) == 293000000, 7357190101021000);

  }
}
// check: EXECUTED
