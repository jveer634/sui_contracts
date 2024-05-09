/// Module: nft_transfer_policy
module nft_transfer_policy::royalty {

    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::transfer_policy::{Self as policy, TransferPolicyCap, TransferPolicy, TransferRequest};
    
    const MAX_BP: u64 = 10_000;
    const EInsufficientAmount: u64 = 0;

    public struct RoyaltyRule has drop {}

    public struct RoyaltyConfig has store, drop {
        royalty: u64
    }

    public fun add<T>(
        policy: &mut TransferPolicy<T>,
        cap: &TransferPolicyCap<T>,
        royalty: u64
    ) {
        policy::add_rule(RoyaltyRule {}, policy, cap, RoyaltyConfig {royalty})
    }


    public fun pay<T>(
        policy: &mut TransferPolicy<T>,
        request: &mut TransferRequest<T>,
        payment: &mut Coin<SUI>,
        ctx: &mut TxContext
    ) {
        let paid = policy::paid(request);
        
        let config: &RoyaltyConfig = policy::get_rule(RoyaltyRule {}, policy);
        
        let amount = (paid * config.royalty) / MAX_BP;
        
        assert!(coin::value(payment) >= amount, EInsufficientAmount);

        let fee = coin::split(payment, amount, ctx);
        policy::add_to_balance(RoyaltyRule {}, policy, fee);
        policy::add_receipt(RoyaltyRule {}, request)
    }

}
