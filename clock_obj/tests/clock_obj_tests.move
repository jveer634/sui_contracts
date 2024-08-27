#[test_only]
module clock_obj::clock_obj_tests {
    use clock_obj::clock_obj;

    use sui::test_scenario;
    use sui::clock;
    const TIME: u64 = 1; // 1 millisecond

    #[test]
    fun test_counter() {
        let user  = @0x12e4;

        let mut scenario = test_scenario::begin(user);
        {
            let ctx = scenario.ctx();
            let mut clock = clock::create_for_testing(ctx);
            clock_obj::new(TIME, &clock, ctx);
            clock.increment_for_testing(1);
            clock.share_for_testing();
        };

        scenario.next_tx(user);
        {
            let mut counter = scenario.take_from_sender<clock_obj::Counter>();
            let clock = scenario.take_shared<clock::Clock>();
            counter.update(&clock);

            scenario.return_to_sender(counter);
            test_scenario::return_shared(clock);
        };
        scenario.end();
    }

    #[test, expected_failure]
    fun test_fail_counter() {
        let user  = @0x12e4;

        let mut scenario = test_scenario::begin(user);
        {
            let ctx = scenario.ctx();
            let clock = clock::create_for_testing(ctx);
            clock_obj::new(TIME, &clock, ctx);
            clock.share_for_testing();
        };

        scenario.next_tx(user);
        {
            let mut counter = scenario.take_from_sender<clock_obj::Counter>();
            let clock = scenario.take_shared<clock::Clock>();
            counter.update(&clock);

            scenario.return_to_sender(counter);
            test_scenario::return_shared(clock);
        };
        scenario.end();
    }
}


