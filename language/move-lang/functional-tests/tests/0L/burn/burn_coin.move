//! account: alice, 1000000GAS, 0, validator

//! new-transaction
//! sender: diemroot
script {
  use 0x1::GAS::GAS;
  use 0x1::Diem;
    
  fun main(vm: signer) {
    let coin = Diem::mint<GAS>(&vm, 10);
    let cap = Diem::market_cap<GAS>();
    Diem::vm_burn_this_coin(&vm, coin);
    let cap_later = Diem::market_cap<GAS>();
    assert(cap_later < cap, 735701);
  }
}

// check: BurnEvent
// check: "Keep(EXECUTED)"