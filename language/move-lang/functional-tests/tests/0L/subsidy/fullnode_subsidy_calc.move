//! account: alice, 100, 0, validator

//! new-transaction
// Check if genesis subsidies have been distributed
//! sender: diemroot
script {
    use 0x1::Subsidy;
    
    fun main(_vm: signer) {
        let value = Subsidy::test_fullnode_subsidy_calc();
        assert(value == 20, 735703);
    }
}
//check: EXECUTED