//! account: dummy-prevents-genesis-reload, 100000 ,0, validator
//! account: alice, 10000000GAS

// Alice Submit VDF Proof
//! new-transaction
//! sender: alice
script {
    use 0x1::MinerState;
    use 0x1::TestFixtures;

    // SIMULATES A MINER ONBOARDING PROOF (block_0.json)
    fun main(sender: signer) {
        let difficulty = 100;
        // return solution
        MinerState::test_helper(
            &sender,
            difficulty,
            TestFixtures::alice_0_easy_chal(),
            TestFixtures::alice_0_easy_sol()
        );

        assert(MinerState::test_helper_get_height(@{{alice}}) == 0, 10008001);
    }
}
// check: EXECUTED


//! new-transaction
//! sender: alice
script {
    use 0x1::MinerState;
    use 0x1::TestFixtures;
    // SIMULATES THE SECOND PROOF OF THE MINER (block_1.json)
    fun main(sender: signer) {
        let difficulty = 100u64;
        assert(MinerState::test_helper_get_height(@{{alice}}) == 0, 10008001);
        let height_after = 1;
        let proof = MinerState::create_proof_blob(
            TestFixtures::alice_1_easy_chal(),
            difficulty,
            TestFixtures::alice_1_easy_sol()
        );

        MinerState::commit_state(&sender, proof);
        let verified_height = MinerState::test_helper_get_height(@{{alice}});
        assert(verified_height == height_after, 10008002);
    }
}
// check: EXECUTED


// //! new-transaction
// //! sender: diemroot
// script {
// use 0x1::MinerState;

// // Simulating the VM calling epoch boundary update_metrics.
// fun main(sender: signer) {
//     //update_metrics
//     // reference:
//     //  previous_proof_hash: vector<u8>,
//     // verified_tower_height: u64, // user's latest verified_tower_height
//     // latest_epoch_mining: u64,
//     // count_proofs_in_epoch: u64,
//     // epochs_validating_and_mining: u64,
//     // contiguous_epochs_validating_and_mining: u64,

//     assert(MinerState::test_helper_get_height(@{{alice}}) == 1, 10009001);
//     assert(MinerState::get_miner_latest_epoch(sender, @{{alice}}) == 1, 10009002);
//     assert(MinerState::get_count_in_epoch(@{{alice}}) == 2, 10009003);
//     assert(MinerState::get_epochs_mining(@{{alice}}) == 0, 10009004);
//     assert(MinerState::test_helper_get_contiguous(@{{alice}}) == 0, 10009005);
    
//     MinerState::test_helper_mock_reconfig(sender, @{{alice}});

//     assert(MinerState::test_helper_get_height(@{{alice}}) == 1, 10009006);
//     assert(MinerState::get_miner_latest_epoch(sender, @{{alice}}) == 1, 10009007);
//     assert(MinerState::get_count_in_epoch(@{{alice}}) == 0, 10009008);
//     assert(MinerState::get_epochs_mining(@{{alice}}) == 1, 10009009);
//     assert(MinerState::test_helper_get_contiguous(@{{alice}}) == 1, 10009010);

// }
// }
// // check: EXECUTED

