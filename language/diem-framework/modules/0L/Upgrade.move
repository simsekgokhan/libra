///////////////////////////////////////////////////////////////////////////
// Upgrade payload
// File Prefix for errors: 2100
///////////////////////////////////////////////////////////////////////////
address 0x1 {
module Upgrade {
    use 0x1::CoreAddresses;
    use 0x1::Errors;
    use 0x1::Signer;
    use 0x1::Vector;

    /// Structs for UpgradePayload resource
    struct UpgradePayload has key {
        payload: vector<u8>, 
    }

    /// Structs for UpgradeHistory resource
    struct UpgradeBlobs has store {
        upgraded_version: u64,
        upgraded_payload: vector<u8>,
        validators_signed: vector<address>,
        consensus_height: u64,
    }

    struct UpgradeHistory has key {
        records: vector<UpgradeBlobs>, 
    }

    // Function code: 01
    public fun initialize(account: &signer) {
        assert(Signer::address_of(account) == CoreAddresses::DIEM_ROOT_ADDRESS(), Errors::requires_role(210001)); 
        move_to(account, UpgradePayload{payload: x""});
        move_to(account, UpgradeHistory{
            records: Vector::empty<UpgradeBlobs>()},
        );
    }

        // Function code: 02
    public fun set_update(account: &signer, payload: vector<u8>) acquires UpgradePayload {
        assert(Signer::address_of(account) == CoreAddresses::DIEM_ROOT_ADDRESS(), Errors::requires_role(210002)); 
        assert(exists<UpgradePayload>(CoreAddresses::DIEM_ROOT_ADDRESS()), Errors::not_published(210002)); 
        let temp = borrow_global_mut<UpgradePayload>(CoreAddresses::DIEM_ROOT_ADDRESS());
        temp.payload = payload;
    }

        // Function code: 03
    public fun reset_payload(account: &signer) acquires UpgradePayload {
        assert(Signer::address_of(account) == CoreAddresses::DIEM_ROOT_ADDRESS(), Errors::requires_role(210003)); 
        assert(exists<UpgradePayload>(CoreAddresses::DIEM_ROOT_ADDRESS()), Errors::not_published(210003)); 
        let temp = borrow_global_mut<UpgradePayload>(CoreAddresses::DIEM_ROOT_ADDRESS());
        temp.payload = Vector::empty<u8>();
    }

        // Function code: 04
    public fun record_history(
        account: &signer, 
        upgraded_version: u64, 
        upgraded_payload: vector<u8>, 
        validators_signed: vector<address>,
        consensus_height: u64,
    ) acquires UpgradeHistory {
        assert(Signer::address_of(account) == CoreAddresses::DIEM_ROOT_ADDRESS(), Errors::requires_role(210004)); 
        let new_record = UpgradeBlobs {
            upgraded_version: upgraded_version,
            upgraded_payload: upgraded_payload,
            validators_signed: validators_signed,
            consensus_height: consensus_height,
        };
        let history = borrow_global_mut<UpgradeHistory>(CoreAddresses::DIEM_ROOT_ADDRESS());
        Vector::push_back(&mut history.records, new_record);
    }

        // Function code: 05
    public fun retrieve_latest_history(): (u64, vector<u8>, vector<address>, u64) acquires UpgradeHistory {
        let history = borrow_global<UpgradeHistory>(CoreAddresses::DIEM_ROOT_ADDRESS());
        let len = Vector::length<UpgradeBlobs>(&history.records);
        if (len == 0) {
            return (0, Vector::empty<u8>(), Vector::empty<address>(), 0)
        };
        let entry = Vector::borrow<UpgradeBlobs>(&history.records, len-1);
        (entry.upgraded_version, *&entry.upgraded_payload, *&entry.validators_signed, entry.consensus_height)
    }

        // Function code: 06
    public fun has_upgrade(): bool acquires UpgradePayload {
        assert(exists<UpgradePayload>(CoreAddresses::DIEM_ROOT_ADDRESS()), Errors::requires_role(210005)); 
        !Vector::is_empty(&borrow_global<UpgradePayload>(CoreAddresses::DIEM_ROOT_ADDRESS()).payload)
    }

        // Function code: 07
    public fun get_payload(): vector<u8> acquires UpgradePayload {
        assert(exists<UpgradePayload>(CoreAddresses::DIEM_ROOT_ADDRESS()), Errors::requires_role(210006));
        *&borrow_global<UpgradePayload>(CoreAddresses::DIEM_ROOT_ADDRESS()).payload
    }

    //////// FOR E2E Testing ////////
    // Do not delete these lines. Uncomment when needed to generate e2e test fixtures. 
    // use 0x1::Debug::print;
    // public fun foo() {
    //     print(&0x050D1AC);
    // }

    //////// FOR E2E Testing ////////
}
}
    