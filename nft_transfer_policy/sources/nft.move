/// Module: nft
module nft_transfer_policy::nft {
    use std::ascii::String;

    use sui::tx_context::sender;
    use nft_transfer_policy::royalty;

    public struct NFT has drop {}

    public struct Token has key, store {
        id: UID,
        name: String,
    }

    #[allow(lint(share_owned))]
    fun init(witness: NFT, ctx: &mut TxContext) {

        let publisher = sui::package::claim(witness, ctx);
        let (mut policy, policyCap) = sui::transfer_policy::new<Token>(&publisher,ctx);

        royalty::add(&mut policy, &policyCap, 100u64);
        transfer::public_share_object(policy);
        transfer::public_transfer(policyCap, tx_context::sender(ctx));
        transfer::public_transfer(publisher, tx_context::sender(ctx));
    }


    public entry fun mint(name: String,  ctx: &mut TxContext) {
        transfer::public_transfer(Token {
            id: object::new(ctx),
            name
        }, sender(ctx));
    }
}
