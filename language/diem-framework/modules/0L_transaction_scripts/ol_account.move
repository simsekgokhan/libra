// Transaction script FOR ONBOARDING. Assumes tower-height 0, and that the 
// challenge has a public key which will be turned into an auth_key and 
// subsequently an address.
// The same algortihm for generating account addresses is available offline. 
// This transaction confirms the address.

address 0x1 {
module AccountScripts {

    use 0x1::Debug::print;
    use 0x1::DiemAccount;
    use 0x1::GAS::GAS;
    use 0x1::ValidatorConfig;
  
    public(script) fun create_acc_user(
        _sender: signer,
        challenge: vector<u8>,
        solution: vector<u8>,
    ) {
        let new_account_address = DiemAccount::create_user_account_with_proof(
            &challenge,
            &solution,
        );

        // Check the account exists and the balance is 0
        assert(DiemAccount::balance<GAS>(new_account_address) == 0, 01);
    }

    public(script) fun create_acc_val(
        sender: signer,
        challenge: vector<u8>,
        solution: vector<u8>,
        ow_human_name: vector<u8>,
        op_address: address,
        op_auth_key_prefix: vector<u8>,
        op_consensus_pubkey: vector<u8>,
        op_validator_network_addresses: vector<u8>,
        op_fullnode_network_addresses: vector<u8>,
        op_human_name: vector<u8>,
    ) {
        print(&0x1);
        let new_account_address = DiemAccount::create_validator_account_with_proof(
            &sender,
            &challenge,
            &solution,
            ow_human_name,
            op_address,
            op_auth_key_prefix,
            op_consensus_pubkey,
            op_validator_network_addresses,
            op_fullnode_network_addresses,
            op_human_name,
        );
        
        print(&0x2);
        // Check the account has the Validator role
        assert(ValidatorConfig::is_valid(new_account_address), 03);
        
        print(&0x3);
        // Check the account exists and the balance is greater than 0
        assert(DiemAccount::balance<GAS>(new_account_address) > 0, 04);
    }

}
}