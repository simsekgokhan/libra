//! account: dummy-prevents-genesis-reload, 100000GAS ,0, validator
//! account: bob, 10000000GAS

// Bob is making proofs too fast, submitting a new proof should fail.

// Setup accounts.

//! new-transaction
//! sender: bob
script {
    use 0x1::MinerState;
    use 0x1::TestFixtures;

    fun main(sender: signer) {
        MinerState::test_helper_init_miner(
            &sender,
            100u64, //difficulty
            TestFixtures::easy_chal(),
            TestFixtures::easy_sol()
        );

        let height = MinerState::test_helper_get_height(@{{bob}});
        assert(height==0, 01);

    }
}
// check: EXECUTED

//! new-transaction
//! sender: bob
script {
    use 0x1::MinerState;
    use 0x1::TestFixtures;

    fun main(sender: signer) {
        MinerState::test_helper_set_proofs_in_epoch(@{{bob}}, 10000);

        let difficulty = 100;
        let proof = MinerState::create_proof_blob(
            TestFixtures::easy_chal(),
            difficulty,
            TestFixtures::easy_sol()
        );
        MinerState::commit_state(&sender, proof);
    }
}
// check: VMExecutionFailure(ABORTED { code: 130106