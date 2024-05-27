/// Module: custom_transfer
module custom_transfer::custom_transfer {
    use sui::vec_map::{Self, VecMap};

    public struct CustomTransfer has key, store {
        id: UID,
        transfers_count: VecMap<ID, u64>
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(CustomTransfer {
            id: object::new(ctx),
            transfers_count: vec_map::empty<ID, u64>()
        }, ctx.sender())
    }
    
    public struct Asset has key {
        id: UID,
        val: u64
    }

    public fun new(c: &mut CustomTransfer, val: u64, ctx: &mut TxContext) {
        let id = object::new(ctx);
        c.transfers_count.insert(id.to_inner(), 0);
        transfer::transfer(Asset {
            id,
            val
        }, ctx.sender())
    }

    // notice: Custom transfer function
    public fun transfer(c: &mut CustomTransfer, asset: Asset, receiver: address) {
       let counter = c.transfers_count.get_mut(&asset.id.to_inner());
        *counter = *counter + 1;
        transfer::transfer(asset, receiver)
    }

    public fun count(c: &CustomTransfer, asset: &Asset): u64 {
        *c.transfers_count.get(&asset.id.to_inner())
    }

    #[test_only]
    public fun init_for_test(ctx: &mut TxContext) {
        init(ctx)
    }
}
