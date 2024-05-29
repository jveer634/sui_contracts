
/// Module: coin_payments
module coin_payments::coin_payments {
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};

    public struct CoinPayments has key {
        id: UID,
        new_fee: u64,
        update_fee: u64,
        balance: Balance<SUI>
    }

    public struct CoinPaymentsCap has key {
        id: UID
    }


    const ENegativeDecrement: u64 = 0;
    const EInvalidPayment: u64 = 1;

    public struct Counter has key,store{
        id: UID,
        val: u64
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(CoinPaymentsCap {
            id: object::new(ctx)
        }, ctx.sender());
        transfer::share_object(CoinPayments {
            id: object::new(ctx),
            new_fee: 1000,
            update_fee: 100,
            balance: balance::zero<SUI>(),
        })
    }

    #[allow(lint(self_transfer))]
    public fun new(cp: &mut CoinPayments, payment: Coin<SUI>, ctx: &mut TxContext) {
        assert!(cp.new_fee == payment.value(), EInvalidPayment);
        coin::put(&mut cp.balance, payment);
        
        transfer::transfer(Counter {
            id: object::new(ctx),
            val:0
        }, ctx.sender())
    }

    public fun increment(c: &mut Counter, cp: &mut CoinPayments, payment: Coin<SUI>) {
        assert!(cp.update_fee == payment.value(), EInvalidPayment);
        coin::put(&mut cp.balance, payment);
        c.val = c.val + 1
    }

    public fun decrement(c: &mut Counter, cp: &mut CoinPayments, payment: Coin<SUI>) {
        assert!(c.val > 0, ENegativeDecrement);
        assert!(cp.update_fee == payment.value(), EInvalidPayment);
        coin::put(&mut cp.balance, payment);
        c.val = c.val - 1
    }

    public fun val(c: &Counter) :u64 {
        c.val
    }

    public entry fun withdraw(cp: &mut CoinPayments, _: &CoinPaymentsCap, ctx: &mut TxContext) {
        let val = cp.balance.value();
        let payment = coin::take(&mut cp.balance, val, ctx);
        transfer::public_transfer(payment, ctx.sender())
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(ctx);
    } 
}

