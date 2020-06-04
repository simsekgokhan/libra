//! Functional test for delay module

#![forbid(unsafe_code)]
use ol_miner::delay;

#[test]
fn test_do_delay() {
    // use a test pre image and a 100 millisecond difficulty
    let proof = delay::Delay::do_delay(b"test preimage",100);

    // print to copy/paste the correct_proof string below.
    println!("proof:\n{:?}", hex::encode(&proof));

    let correct_proof = hex::decode("005b427f7c2e67c60b5b2c48975813632c7c467eaae664f304732b23b01f59e0fce9c881844b8e13978ab29dcc5a2c111ccadd31a008ea26481d8e55c63e120f5515e29040a0916db86a8c374f424508a55c16984556bcb83af74b4ce8138bcca61fc7e4d74082cba3d06127ab5d1ced59f56429c360f2fd1d68cf9ab2a7b73b52ffeaccf8b9e987e7e854f895d8bc4a637cc46b92b46aca79514c1ebb62692b83198617a7f2b81e69deda8281362cd0fb617e123517a1be308f530e795cb3695ece1a05f34561d14c8756d0eda3f3d0c6628d9e4d7a5c5d9ca696fa05b954ccf86b5b5a126e153a8212842af3a4567dd9321a6f8c92ee93fd23e25e4af619894a4d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001").unwrap();

    //println!("decoded:\n{:?}", correct_proof);

    assert_eq!(proof, correct_proof, "proof is incorrect");


}
