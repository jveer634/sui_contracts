
/// Module: Counter
module soul_bound_object::counter {

    use soul_bound_object::registry::{AuthProxy};

    public struct Counter has key, store {
        id: UID,
        val: u64
    }

    public entry fun get_counter(_: &AuthProxy, ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            val: 0
        };

        transfer::public_transfer(counter, tx_context::sender(ctx))
    }


    public entry fun increment(c: &mut Counter) {
        c.val = c.val + 1
    }

    public fun val(c: &Counter): u64 {
        c.val
    }

}