/////////////////////////////////////////////////////////////////////////
// Error Code: 0500
/////////////////////////////////////////////////////////////////////////

address 0x1 {

/// # Summary 
/// This module allows the root to determine epoch boundaries, triggering 
/// epoch change operations (e.g. updating the validator set)
module Epoch {
  use 0x1::DiemTimestamp;
  use 0x1::CoreAddresses;
  use 0x1::Globals;
  use 0x1::DiemConfig;
  use 0x1::Roles;

  /// Contains timing info for the current epoch
  /// epoch: the epoch number
  /// height_start: the block height the epoch started at
  /// seconds_start: the start time of the epoch
  struct Timer has key { 
      epoch: u64,
      height_start: u64,
      seconds_start: u64
  }

  // Function code:01
  /// Called in genesis to initialize timer
  public fun initialize(vm: &signer) {
      Roles::assert_diem_root(vm);
      move_to<Timer>(
      vm, 
      Timer {
          epoch: 0,
          height_start: 0,
          seconds_start: DiemTimestamp::now_seconds()
          }
      );
  }

  /// Check to see if epoch is finished 
  /// Simply checks if the elapsed time is greater than the epoch time 
  public fun epoch_finished(): bool acquires Timer {
      let epoch_secs = Globals::get_epoch_length();
      let time = borrow_global<Timer>(CoreAddresses::DIEM_ROOT_ADDRESS());
      DiemTimestamp::now_seconds() > (epoch_secs + time.seconds_start)
  }

  // Function code:02
  /// Reset the timer to start the next epoch 
  /// Called by root in the reconfiguration process
  public fun reset_timer(vm: &signer, height: u64) acquires Timer {
      Roles::assert_diem_root(vm);
      let time = borrow_global_mut<Timer>(CoreAddresses::DIEM_ROOT_ADDRESS());
      time.epoch = DiemConfig::get_current_epoch() + 1;
      time.height_start = height;
      time.seconds_start = DiemTimestamp::now_seconds();
  }

  /// Accessor Function, returns the time (in seconds) of the start of the current epoch
  public fun get_timer_seconds_start(vm: &signer):u64 acquires Timer {
      Roles::assert_diem_root(vm);
      let time = borrow_global<Timer>(CoreAddresses::DIEM_ROOT_ADDRESS());
      time.seconds_start
  }

  /// Accessor Function, returns the block height of the start of the current epoch
  public fun get_timer_height_start(vm: &signer):u64 acquires Timer {
      Roles::assert_diem_root(vm);
      let time = borrow_global<Timer>(CoreAddresses::DIEM_ROOT_ADDRESS());
      time.height_start
  }
}
}