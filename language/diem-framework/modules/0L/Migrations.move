address 0x1 {

module Migrations {
  use 0x1::Vector;
  use 0x1::CoreAddresses;
  use 0x1::Option::{Self,Option};

  struct Migrations has key {
    list: vector<Job>
  }

  struct Job has copy, drop, store {
    uid: u64,
    name: vector<u8>, // experiment with using text labels
  }

  public fun init(vm: &signer){
    CoreAddresses::assert_diem_root(vm);
    if (!exists<Migrations>(@0x0)) {
      move_to<Migrations>(vm, Migrations {
        list: Vector::empty<Job>(),
      })
    }
  }

  public fun has_run(uid: u64): bool acquires Migrations {
    let opt_job = find(uid);
    if (Option::is_some<Job>(&opt_job)) {
      return true
    };
    false
  }

  public fun push(uid: u64, text: vector<u8>) acquires Migrations {   
    if (has_run(uid)) return;
    let s = borrow_global_mut<Migrations>(@0x0);
    let j = Job {
      uid: uid,
      name: text,
    };

    Vector::push_back<Job>(&mut s.list, j);
  }

  fun find(uid: u64): Option<Job> acquires Migrations {
    let job_list = &borrow_global<Migrations>(@0x0).list;
    let len = Vector::length(job_list);
    let i = 0;
    while (i < len) {
      let j = *Vector::borrow<Job>(job_list, i);
      if (j.uid == uid) {
        return Option::some<Job>(j)
      };
      i = i + 1;
    };
    Option::none<Job>()
  }
}

/// Module providing debug functionality.
module MigrateWallets {
  // migrations should have own module, since imports can cause dependency cycling.
  use 0x1::Vector;
  use 0x1::Migrations;
  use 0x1::DiemAccount;
  use 0x1::ValidatorUniverse;

  const UID: u64 = 10;

  public fun migrate_slow_wallets(vm: &signer) {

    let vec_addr = ValidatorUniverse::get_eligible_validators(vm);
    
    // tag as 
    let len = Vector::length<address>(&vec_addr);
    let i = 0;
    while (i < len) {
      let addr = *Vector::borrow<address>(&vec_addr, i);
      DiemAccount::vm_migrate_slow_wallet(vm, addr);
      i = i + 1;
    };
    Migrations::push(UID, b"MigrateWallets");
  }

}
}