//# init --validators Alice
//#      --addresses Bob=0x2e3a0b7a741dae873bf0f203a82dfd52
//#                  Carol=0x4b7653f6566a52c9b496f245628a69a0
//#      --private-keys Bob=e1acb70a23dba96815db374b86c5ae96d6a9bc5fff072a7a8e55a1c27c1852d8
//#                     Carol=f5fd1521bd82454a9834ef977c389a0201f9525b11520334842ab73d2dcbf8b7

//# run --signers DiemRoot
//#     --args @Bob
//#     -- 0x1::DiemAccount::test_harness_create_user

//# run --signers DiemRoot
//#     --args @Carol
//#     -- 0x1::DiemAccount::test_harness_create_user



// make Alice a case 1 validator, so that she is in the next validator set.

//# run --admin-script --signers DiemRoot Alice
script {    
    use DiemFramework::TowerState;
    use DiemFramework::Burn;
    use DiemFramework::Audit;
    use DiemFramework::AutoPay;

    fun main(_dr: signer, sender: signer) {
        // Alice is the only one that can update her mining stats. 
        // Hence this first transaction.

        TowerState::test_helper_mock_mining(&sender, 5);
        // set alice burn preferences as sending to community wallets.
        Burn::set_send_community(&sender, true);
        // validator needs to qualify for next epoch for the burn to register
        Audit::test_helper_make_passing(&sender);
        AutoPay::enable_autopay(&sender);
    }
}
//check: EXECUTED

//# run --admin-script --signers DiemRoot DiemRoot
script {
    use DiemFramework::Stats;
    use Std::Vector;
    use DiemFramework::Cases;

    fun main(vm: signer, _account: signer) {
        let vm = &vm;
        let voters = Vector::singleton<address>(@Alice);
        let i = 1;
        while (i < 16) {
            // Mock the validator doing work for 15 blocks, and stats being updated.
            Stats::process_set_votes(vm, &voters);
            i = i + 1;
        };

        assert!(Cases::get_case(vm, @Alice, 0 , 15) == 1, 7357300103011000);
    }
}
//check: EXECUTED

//# run --admin-script --signers DiemRoot Bob
script {
    use DiemFramework::Wallet;
    use Std::Vector;
    use DiemFramework::GAS::GAS;
    use Std::Signer;
    use DiemFramework::DiemAccount;

    fun main(_dr: signer, sender: signer) {
      Wallet::set_comm(&sender);
      let bal = DiemAccount::balance<GAS>(Signer::address_of(&sender));
      DiemAccount::init_cumulative_deposits(&sender, bal);
      let list = Wallet::get_comm_list();
      assert!(Vector::length(&list) == 1, 7357001);
    }
}

// check: EXECUTED

//# run --admin-script --signers DiemRoot Carol
script {
    use DiemFramework::Wallet;
    use Std::Vector;
    use DiemFramework::GAS::GAS;
    use Std::Signer;
    use DiemFramework::DiemAccount;

    fun main(_dr: signer, sender: signer) {
      Wallet::set_comm(&sender);
      let bal = DiemAccount::balance<GAS>(Signer::address_of(&sender));
      DiemAccount::init_cumulative_deposits(&sender, bal);
      let list = Wallet::get_comm_list();
      assert!(Vector::length(&list) == 2, 7357002);
    }
}
// check: EXECUTED

//# run --admin-script --signers DiemRoot DiemRoot
script {
  use DiemFramework::DiemAccount;
  use DiemFramework::GAS::GAS;

  fun main(vm: signer, _account: signer) {
    // send to community wallet Bob
    DiemAccount::vm_make_payment_no_limit<GAS>(@Alice, @Bob, 500000, x"", x"", &vm);
    let bal = DiemAccount::balance<GAS>(@Bob);
    assert!(bal == 500000, 7357003);
  }
}
// check: EXECUTED

//////////////////////////////////////////////
//// Trigger reconfiguration at 61 seconds ////
//# block --proposer Alice --time 61000000 --round 15

////// TEST RECONFIGURATION IS HAPPENING /////
// check: NewEpochEvent
//////////////////////////////////////////////

//# run --admin-script --signers DiemRoot DiemRoot
script {
  use DiemFramework::DiemAccount;
  use DiemFramework::GAS::GAS;
  use DiemFramework::Debug::print;

  fun main() {
    // bob's community wallet increased by 50% of subsidy after epoch change.
    let bal = DiemAccount::balance<GAS>(@Bob);
    print(&bal);
    assert!(bal == 148500000, 7357004);    
  }
}
// check: EXECUTED