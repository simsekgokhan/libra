// ! account: bob, 1230000GAS, 0, validator

//! new-transaction
//! sender: diemroot
script {
  // use 0x1::Debug::print;
  use 0x1::DiemAccount;
  use 0x1::GAS::GAS;
  fun main(_: signer) {
    // need to remove testnet for this test, since testnet does not ratelimit account creation.
    
    let bal = DiemAccount::balance<GAS>(@{{bob}});
    assert(bal == 1230000, 7357001);
    // print(&bal);
  }
}