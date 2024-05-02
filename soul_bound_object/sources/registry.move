
/// Module: Registry
module soul_bound_object::registry {

    public struct AuthProxy has key {
        id: UID
    }


    public entry fun register(ctx: &mut TxContext) {
        let authProxy = AuthProxy {
            id: object::new(ctx),
        };

        transfer::transfer(authProxy, tx_context::sender(ctx))
    } 


}

