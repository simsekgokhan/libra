
<a name="0x1_Cases"></a>

# Module `0x1::Cases`


<a name="@Summary_0"></a>

## Summary

This module can be used by root to determine whether a validator is compliant
Validators who are no longer compliant may be kicked out of the validator
set and/or jailed. To be compliant, validators must be BOTH validating and mining.


-  [Summary](#@Summary_0)
-  [Constants](#@Constants_1)
-  [Function `get_case`](#0x1_Cases_get_case)


<pre><code><b>use</b> <a href="MinerState.md#0x1_MinerState">0x1::MinerState</a>;
<b>use</b> <a href="Roles.md#0x1_Roles">0x1::Roles</a>;
<b>use</b> <a href="Stats.md#0x1_Stats">0x1::Stats</a>;
</code></pre>



<a name="@Constants_1"></a>

## Constants


<a name="0x1_Cases_VALIDATOR_COMPLIANT"></a>



<pre><code><b>const</b> <a href="Cases.md#0x1_Cases_VALIDATOR_COMPLIANT">VALIDATOR_COMPLIANT</a>: u64 = 1;
</code></pre>



<a name="0x1_Cases_VALIDATOR_DOUBLY_NOT_COMPLIANT"></a>



<pre><code><b>const</b> <a href="Cases.md#0x1_Cases_VALIDATOR_DOUBLY_NOT_COMPLIANT">VALIDATOR_DOUBLY_NOT_COMPLIANT</a>: u64 = 4;
</code></pre>



<a name="0x1_Cases_VALIDATOR_HALF_COMPLIANT"></a>



<pre><code><b>const</b> <a href="Cases.md#0x1_Cases_VALIDATOR_HALF_COMPLIANT">VALIDATOR_HALF_COMPLIANT</a>: u64 = 2;
</code></pre>



<a name="0x1_Cases_VALIDATOR_NOT_COMPLIANT"></a>



<pre><code><b>const</b> <a href="Cases.md#0x1_Cases_VALIDATOR_NOT_COMPLIANT">VALIDATOR_NOT_COMPLIANT</a>: u64 = 3;
</code></pre>



<a name="0x1_Cases_get_case"></a>

## Function `get_case`



<pre><code><b>public</b> <b>fun</b> <a href="Cases.md#0x1_Cases_get_case">get_case</a>(vm: &signer, node_addr: address, height_start: u64, height_end: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Cases.md#0x1_Cases_get_case">get_case</a>(vm: &signer, node_addr: address, height_start: u64, height_end: u64): u64 {
    <a href="Roles.md#0x1_Roles_assert_diem_root">Roles::assert_diem_root</a>(vm);
    // did the validator sign blocks above threshold?
    <b>let</b> signs = <a href="Stats.md#0x1_Stats_node_above_thresh">Stats::node_above_thresh</a>(vm, node_addr, height_start, height_end);
    <b>let</b> mines = <a href="MinerState.md#0x1_MinerState_node_above_thresh">MinerState::node_above_thresh</a>(vm, node_addr);

    <b>if</b> (signs && mines) {
        <a href="Cases.md#0x1_Cases_VALIDATOR_COMPLIANT">VALIDATOR_COMPLIANT</a> // compliant: in next set, gets paid, weight increments
    }
    <b>else</b> <b>if</b> (signs && !mines) {
        <a href="Cases.md#0x1_Cases_VALIDATOR_HALF_COMPLIANT">VALIDATOR_HALF_COMPLIANT</a> // half compliant: not in next set, does not get paid, weight does not increment.
    }
    <b>else</b> <b>if</b> (!signs && mines) {
        <a href="Cases.md#0x1_Cases_VALIDATOR_NOT_COMPLIANT">VALIDATOR_NOT_COMPLIANT</a> // not compliant: jailed, not in next set, does not get paid, weight increments.
    }
    <b>else</b> {
        <a href="Cases.md#0x1_Cases_VALIDATOR_DOUBLY_NOT_COMPLIANT">VALIDATOR_DOUBLY_NOT_COMPLIANT</a> // not compliant: jailed, not in next set, does not get paid, weight does not increment.
    }
}
</code></pre>



</details>


[//]: # ("File containing references which can be used from documentation")
[ACCESS_CONTROL]: https://github.com/diem/dip/blob/main/dips/dip-2.md
[ROLE]: https://github.com/diem/dip/blob/main/dips/dip-2.md#roles
[PERMISSION]: https://github.com/diem/dip/blob/main/dips/dip-2.md#permissions
