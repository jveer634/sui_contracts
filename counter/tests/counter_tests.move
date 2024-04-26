#[test_only]
module counter::counter_tests {
    use counter::counter;

    const EInvalidCounterInit: u64 = 0;
    const EIncrementFailed: u64 = 0;

    use sui::test_scenario;

    #[test]
    fun test_new_counter() {
        let user  = @0x12e4;

        let mut scenario = test_scenario::begin(user);
        {
            let ctx = scenario.ctx();
            let c = counter::new(ctx);
            assert!(c.val() == 0, EInvalidCounterInit);
            transfer::public_transfer(c, scenario.sender());
        };

        scenario.end();
    }

    #[test]
    fun test_increment() {
         let user  = @0x12e4;

        let mut scenario = test_scenario::begin(user);
        {
            let ctx = scenario.ctx();
            let c = counter::new(ctx);
            assert!(c.val() == 0, EInvalidCounterInit);
            transfer::public_transfer(c, scenario.sender());
        };

        scenario.next_tx(user);
        {
            let mut c = test_scenario::take_from_sender<counter::Counter>(&scenario);
            c.increment();
            assert!(c.val() == 1, EIncrementFailed);
            transfer::public_transfer(c, scenario.sender());
        };
        scenario.end();
    }

     #[test, expected_failure(abort_code= counter::ENegativeDecrement)]
    fun test_decrement_fail() {
         let user  = @0x12e4;

        let mut scenario = test_scenario::begin(user);
        {
            let ctx = scenario.ctx();
            let mut c = counter::new(ctx);
            c.decrement();
            transfer::public_transfer(c, scenario.sender());
        };
        
        scenario.end();
    }
    #[test]
    fun test_decrement() {
         let user  = @0x12e4;

        let mut scenario = test_scenario::begin(user);
        {
            let ctx = scenario.ctx();
            let mut c = counter::new(ctx);
            c.increment();
            c.increment();
            assert!(c.val() == 2, EInvalidCounterInit);
            transfer::public_transfer(c, scenario.sender());
        };

        scenario.next_tx(user);
        {
            let mut c = test_scenario::take_from_sender<counter::Counter>(&scenario);
            c.decrement();
            assert!(c.val() == 1, EIncrementFailed);
            transfer::public_transfer(c, scenario.sender());
        };
        scenario.end();
    }
}


