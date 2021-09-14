
<a name="0x1_Audit"></a>

# Module `0x1::Audit`



-  [Function `val_audit_passing`](#0x1_Audit_val_audit_passing)
-  [Function `make_passing`](#0x1_Audit_make_passing)


<pre><code><b>use</b> <a href="AutoPay.md#0x1_AutoPay2">0x1::AutoPay2</a>;
<b>use</b> <a href="DiemAccount.md#0x1_DiemAccount">0x1::DiemAccount</a>;
<b>use</b> <a href="GAS.md#0x1_GAS">0x1::GAS</a>;
<b>use</b> <a href="MinerState.md#0x1_MinerState">0x1::MinerState</a>;
<b>use</b> <a href="Testnet.md#0x1_Testnet">0x1::Testnet</a>;
<b>use</b> <a href="ValidatorConfig.md#0x1_ValidatorConfig">0x1::ValidatorConfig</a>;
</code></pre>



<a name="0x1_Audit_val_audit_passing"></a>

## Function `val_audit_passing`



<pre><code><b>public</b> <b>fun</b> <a href="Audit.md#0x1_Audit_val_audit_passing">val_audit_passing</a>(val: address): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Audit.md#0x1_Audit_val_audit_passing">val_audit_passing</a>(val: address): bool {
  // has valid configs
  <b>if</b> (!<a href="ValidatorConfig.md#0x1_ValidatorConfig_is_valid">ValidatorConfig::is_valid</a>(val)) <b>return</b> <b>false</b>;
  // has operator account set <b>to</b> another address
  <b>let</b> oper = <a href="ValidatorConfig.md#0x1_ValidatorConfig_get_operator">ValidatorConfig::get_operator</a>(val);
  <b>if</b> (oper == val) <b>return</b> <b>false</b>;
  // operator account has balance
  <b>if</b> (<a href="DiemAccount.md#0x1_DiemAccount_balance">DiemAccount::balance</a>&lt;<a href="GAS.md#0x1_GAS">GAS</a>&gt;(oper) &lt; 50000 && !<a href="Testnet.md#0x1_Testnet_is_testnet">Testnet::is_testnet</a>()) <b>return</b> <b>false</b>;
  // has autopay enabled
  <b>if</b> (!<a href="AutoPay.md#0x1_AutoPay2_is_enabled">AutoPay2::is_enabled</a>(val)) <b>return</b> <b>false</b>;
  // has mining state
  <b>if</b> (!<a href="MinerState.md#0x1_MinerState_is_init">MinerState::is_init</a>(val)) <b>return</b> <b>false</b>;
  // is a slow wallet
  <b>if</b> (!<a href="DiemAccount.md#0x1_DiemAccount_is_slow">DiemAccount::is_slow</a>(val)) <b>return</b> <b>false</b>;

  // TODO: has network settings for validator

  <b>true</b>
}
</code></pre>



</details>

<a name="0x1_Audit_make_passing"></a>

## Function `make_passing`



<pre><code><b>public</b> <b>fun</b> <a href="Audit.md#0x1_Audit_make_passing">make_passing</a>(val: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Audit.md#0x1_Audit_make_passing">make_passing</a>(val: &signer){
  <a href="AutoPay.md#0x1_AutoPay2_enable_autopay">AutoPay2::enable_autopay</a>(val);
}
</code></pre>



</details>


[//]: # ("File containing references which can be used from documentation")
[ACCESS_CONTROL]: https://github.com/diem/dip/blob/main/dips/dip-2.md
[ROLE]: https://github.com/diem/dip/blob/main/dips/dip-2.md#roles
[PERMISSION]: https://github.com/diem/dip/blob/main/dips/dip-2.md#permissions
