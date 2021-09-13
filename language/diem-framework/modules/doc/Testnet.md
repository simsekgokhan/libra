
<a name="0x1_StagingNet"></a>

# Module `0x1::StagingNet`



-  [Resource `IsStagingNet`](#0x1_StagingNet_IsStagingNet)
-  [Function `initialize`](#0x1_StagingNet_initialize)
-  [Function `is_staging_net`](#0x1_StagingNet_is_staging_net)


<pre><code><b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="../../../../../../move-stdlib/docs/Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="../../../../../../move-stdlib/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
</code></pre>



<a name="0x1_StagingNet_IsStagingNet"></a>

## Resource `IsStagingNet`



<pre><code><b>struct</b> <a href="Testnet.md#0x1_StagingNet_IsStagingNet">IsStagingNet</a> has key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_StagingNet_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="Testnet.md#0x1_StagingNet_initialize">initialize</a>(account: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Testnet.md#0x1_StagingNet_initialize">initialize</a>(account: &signer) {
    <b>assert</b>(<a href="../../../../../../move-stdlib/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) == <a href="CoreAddresses.md#0x1_CoreAddresses_DIEM_ROOT_ADDRESS">CoreAddresses::DIEM_ROOT_ADDRESS</a>(), <a href="../../../../../../move-stdlib/docs/Errors.md#0x1_Errors_requires_role">Errors::requires_role</a>(190301));
    move_to(account, <a href="Testnet.md#0x1_StagingNet_IsStagingNet">IsStagingNet</a>{})
}
</code></pre>



</details>

<a name="0x1_StagingNet_is_staging_net"></a>

## Function `is_staging_net`



<pre><code><b>public</b> <b>fun</b> <a href="Testnet.md#0x1_StagingNet_is_staging_net">is_staging_net</a>(): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Testnet.md#0x1_StagingNet_is_staging_net">is_staging_net</a>(): bool {
    <b>exists</b>&lt;<a href="Testnet.md#0x1_StagingNet_IsStagingNet">IsStagingNet</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_DIEM_ROOT_ADDRESS">CoreAddresses::DIEM_ROOT_ADDRESS</a>())
}
</code></pre>



</details>


[//]: # ("File containing references which can be used from documentation")
[ACCESS_CONTROL]: https://github.com/diem/dip/blob/main/dips/dip-2.md
[ROLE]: https://github.com/diem/dip/blob/main/dips/dip-2.md#roles
[PERMISSION]: https://github.com/diem/dip/blob/main/dips/dip-2.md#permissions
