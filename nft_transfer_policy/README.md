# Transfer Policy

In this we have a created a NFT contract with a transfer policy applied to it. Every asset requires a Transfer policy to trade in kiosk marketplace. If the NFT doesn't have any transfer policies, the kiosk will create a new with no rules. But if we want to assign any rules, we must create a transfer policy and attach rules to it.

We can do them on both PTB and on contracts as possible. In this package, we can see how to apply transfer policies right when the contract is publised.

If the `TransferPolicyCap` holder decides that the policy is no longer need, they can remove it or else can also add another policies using `sui::transfer_policy` package.

The package contains 2 modules

-   nft : The nft contract
-   royalty: Royalty rule for the nft
