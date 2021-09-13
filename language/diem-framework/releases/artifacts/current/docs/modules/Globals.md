
<a name="0x1_Globals"></a>

# Module `0x1::Globals`


<a name="@Summary_0"></a>

## Summary

This module provides global variables and constants that have no specific owner


-  [Summary](#@Summary_0)
-  [Struct `GlobalConstants`](#0x1_Globals_GlobalConstants)
-  [Function `get_epoch_length`](#0x1_Globals_get_epoch_length)
-  [Function `get_max_validator_per_epoch`](#0x1_Globals_get_max_validator_per_epoch)
-  [Function `get_subsidy_ceiling_gas`](#0x1_Globals_get_subsidy_ceiling_gas)
-  [Function `get_max_node_density`](#0x1_Globals_get_max_node_density)
-  [Function `get_burn_accounts`](#0x1_Globals_get_burn_accounts)
-  [Function `get_difficulty`](#0x1_Globals_get_difficulty)
-  [Function `get_mining_threshold`](#0x1_Globals_get_mining_threshold)
-  [Function `get_constants`](#0x1_Globals_get_constants)


<pre><code><b>use</b> <a href="Diem.md#0x1_Diem">0x1::Diem</a>;
<b>use</b> <a href="../../../../../../move-stdlib/docs/Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="GAS.md#0x1_GAS">0x1::GAS</a>;
<b>use</b> <a href="Testnet.md#0x1_StagingNet">0x1::StagingNet</a>;
<b>use</b> <a href="Testnet.md#0x1_Testnet">0x1::Testnet</a>;
<b>use</b> <a href="../../../../../../move-stdlib/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_Globals_GlobalConstants"></a>

## Struct `GlobalConstants`

Global constants determining validator settings & requirements
Some constants need to changed based on environment; dev, testing, prod.
epoch_length: The length of an epoch in seconds (~1 day for prod.)
max_validator_per_epoch: The maximum number of validators that can participate
subsidy_ceiling_gas: TODO I don't really know what this is
min_node_density: The minimum number of nodes that can receive a subsidy
max_node_density: The maximum number of nodes that can receive a subsidy
burn_accounts: The address to which burnt tokens should be sent
difficulty: The difficulty required for VDF proofs submitting by miners
epoch_mining_threshold: The number of proofs that must be submitted each
epoch by a miner to remain compliant


<pre><code><b>struct</b> <a href="Globals.md#0x1_Globals_GlobalConstants">GlobalConstants</a> has drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>epoch_length: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>max_validator_per_epoch: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>subsidy_ceiling_gas: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>min_node_density: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>max_node_density: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>burn_accounts: vector&lt;address&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>difficulty: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>epoch_mining_threshold: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_Globals_get_epoch_length"></a>

## Function `get_epoch_length`

Get the epoch length


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_epoch_length">get_epoch_length</a>(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_epoch_length">get_epoch_length</a>(): u64 {
   <a href="Globals.md#0x1_Globals_get_constants">get_constants</a>().epoch_length
}
</code></pre>



</details>

<a name="0x1_Globals_get_max_validator_per_epoch"></a>

## Function `get_max_validator_per_epoch`

Get max validator per epoch


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_max_validator_per_epoch">get_max_validator_per_epoch</a>(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_max_validator_per_epoch">get_max_validator_per_epoch</a>(): u64 {
   <a href="Globals.md#0x1_Globals_get_constants">get_constants</a>().max_validator_per_epoch
}
</code></pre>



</details>

<a name="0x1_Globals_get_subsidy_ceiling_gas"></a>

## Function `get_subsidy_ceiling_gas`

Get max validator per epoch


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_subsidy_ceiling_gas">get_subsidy_ceiling_gas</a>(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_subsidy_ceiling_gas">get_subsidy_ceiling_gas</a>(): u64 {
   <a href="Globals.md#0x1_Globals_get_constants">get_constants</a>().subsidy_ceiling_gas
}
</code></pre>



</details>

<a name="0x1_Globals_get_max_node_density"></a>

## Function `get_max_node_density`

Get max validator per epoch


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_max_node_density">get_max_node_density</a>(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_max_node_density">get_max_node_density</a>(): u64 {
   <a href="Globals.md#0x1_Globals_get_constants">get_constants</a>().max_node_density
}
</code></pre>



</details>

<a name="0x1_Globals_get_burn_accounts"></a>

## Function `get_burn_accounts`

Get the burn accounts


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_burn_accounts">get_burn_accounts</a>(): vector&lt;address&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_burn_accounts">get_burn_accounts</a>(): vector&lt;address&gt; {
   *&<a href="Globals.md#0x1_Globals_get_constants">get_constants</a>().burn_accounts
}
</code></pre>



</details>

<a name="0x1_Globals_get_difficulty"></a>

## Function `get_difficulty`

Get the current difficulty


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_difficulty">get_difficulty</a>(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_difficulty">get_difficulty</a>(): u64 {
  <a href="Globals.md#0x1_Globals_get_constants">get_constants</a>().difficulty
}
</code></pre>



</details>

<a name="0x1_Globals_get_mining_threshold"></a>

## Function `get_mining_threshold`

Get the mining threshold


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_mining_threshold">get_mining_threshold</a>(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Globals.md#0x1_Globals_get_mining_threshold">get_mining_threshold</a>(): u64 {
  <a href="Globals.md#0x1_Globals_get_constants">get_constants</a>().epoch_mining_threshold
}
</code></pre>



</details>

<a name="0x1_Globals_get_constants"></a>

## Function `get_constants`

get the constants for the current network


<pre><code><b>fun</b> <a href="Globals.md#0x1_Globals_get_constants">get_constants</a>(): <a href="Globals.md#0x1_Globals_GlobalConstants">Globals::GlobalConstants</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Globals.md#0x1_Globals_get_constants">get_constants</a>(): <a href="Globals.md#0x1_Globals_GlobalConstants">GlobalConstants</a> {

  <b>let</b> coin_scale = 1000000; //<a href="Diem.md#0x1_Diem_scaling_factor">Diem::scaling_factor</a>&lt;GAS::T&gt;();
  <b>assert</b>(coin_scale == <a href="Diem.md#0x1_Diem_scaling_factor">Diem::scaling_factor</a>&lt;<a href="GAS.md#0x1_GAS_GAS">GAS::GAS</a>&gt;(), <a href="../../../../../../move-stdlib/docs/Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(070001));

  <b>if</b> (<a href="Testnet.md#0x1_Testnet_is_testnet">Testnet::is_testnet</a>()) {
    <b>return</b> <a href="Globals.md#0x1_Globals_GlobalConstants">GlobalConstants</a> {
      epoch_length: 60, // seconds
      max_validator_per_epoch: 10,
      subsidy_ceiling_gas: 296 * coin_scale,
      min_node_density: 4,
      max_node_density: 300,
      burn_accounts: <a href="../../../../../../move-stdlib/docs/Vector.md#0x1_Vector_singleton">Vector::singleton</a>(@0xDEADDEAD),
      difficulty: 100,
      epoch_mining_threshold: 1,
    }

  } <b>else</b> {
    <b>if</b> (<a href="Testnet.md#0x1_StagingNet_is_staging_net">StagingNet::is_staging_net</a>()){
    <b>return</b> <a href="Globals.md#0x1_Globals_GlobalConstants">GlobalConstants</a> {
      epoch_length: 60 * 20, // 20 mins, enough for a hard miner proof.
      max_validator_per_epoch: 300,
      subsidy_ceiling_gas: 8640000 * coin_scale,
      min_node_density: 4,
      max_node_density: 300,
      burn_accounts: <a href="../../../../../../move-stdlib/docs/Vector.md#0x1_Vector_singleton">Vector::singleton</a>(@0xDEADDEAD),
      difficulty: 5000000,
      epoch_mining_threshold: 1,
    }
  } <b>else</b> {
      <b>return</b> <a href="Globals.md#0x1_Globals_GlobalConstants">GlobalConstants</a> {
      epoch_length: 60 * 60 * 24, // approx 24 hours at 1.4 blocks/sec
      max_validator_per_epoch: 300, // max expected for BFT limits.
      // See <a href="DiemVMConfig.md#0x1_DiemVMConfig">DiemVMConfig</a> for gas constants:
      // Target max gas units per transaction 100000000
      // target max block time: 2 secs
      // target transaction per sec max gas: 20
      // uses "scaled representation", since there are no decimals.
      subsidy_ceiling_gas: 8640000 * coin_scale, // subsidy amount assumes 24 hour epoch lengths. Also needs <b>to</b> be adjusted for coin_scale the onchain representation of human readable value.
      min_node_density: 4,
      max_node_density: 300,
      burn_accounts: <a href="../../../../../../move-stdlib/docs/Vector.md#0x1_Vector_singleton">Vector::singleton</a>(@0xDEADDEAD),
      difficulty: 5000000, //10 mins on macbook pro 2.5 ghz quadcore
      epoch_mining_threshold: 20,
      }
    }
  }
}
</code></pre>



</details>


[//]: # ("File containing references which can be used from documentation")
[ACCESS_CONTROL]: https://github.com/diem/dip/blob/main/dips/dip-2.md
[ROLE]: https://github.com/diem/dip/blob/main/dips/dip-2.md#roles
[PERMISSION]: https://github.com/diem/dip/blob/main/dips/dip-2.md#permissions
