//! account: alice, 1000000, 0, validator

// Test audit function val_audit_passing having not enough balance
//! new-transaction
//! sender: diemroot
//! execute-as: alice
script {
    use 0x1::Audit;
    use 0x1::ValidatorConfig;
    use 0x1::AutoPay2;
    use 0x1::MinerState;
    use 0x1::GAS::GAS;
    use 0x1::DiemAccount;
    use 0x1::Testnet;
    
    fun main(vm: signer, alice_account: signer) {
        // Need to unset testnet to properly test this function
        Testnet::remove_testnet(&vm);
        // enable autopay
        AutoPay2::enable_autopay(&alice_account);
        assert(AutoPay2::is_enabled(@{{alice}}), 7357007002001);
        assert(ValidatorConfig::is_valid(@{{alice}}), 7357007002002);
        assert(MinerState::is_init(@{{alice}}), 7357007002003);
        
        // check operator zero balance
        let oper = ValidatorConfig::get_operator(@{{alice}});
        // operator should get 1 GAS from owner at genesis
        assert(DiemAccount::balance<GAS>(oper) == 1000000, 7357007002004);

        // should pass audit.
        assert(Audit::val_audit_passing(@{{alice}}), 7357007002005);
        // transfer not enough balance to operator
        let oper = ValidatorConfig::get_operator(@{{alice}});
        // Drain the operator account
        DiemAccount::vm_make_payment_no_limit<GAS>(
            oper,
            @{{alice}},
            1000000,
            x"",
            x"",
            &vm
        );
        assert(DiemAccount::balance<GAS>(oper) == 0, 7357007002006);
        assert(!Audit::val_audit_passing(@{{alice}}), 7357007002007);
    }
}
// check: EXECUTED