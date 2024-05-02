
#[test_only]
module soul_bound_object::soul_bound_object_tests {
    use soul_bound_object::registry;
    use soul_bound_object::counter;
    use sui::test_scenario;

    #[test]
    fun test_soul_bound_object() {
        let user: address = @123;

        let mut scenario = test_scenario::begin(user);
        {
            let ctx = scenario.ctx();
            registry::register(ctx);
        };

        scenario.next_tx(user);
        {

            let proxy = scenario.take_from_sender<registry::AuthProxy>();
            let ctx = scenario.ctx();
            counter::get_counter(&proxy, ctx);
            scenario.return_to_sender( proxy)
        };

        scenario.next_tx(user);
        {
            let mut c = test_scenario::take_from_sender<counter::Counter>(&scenario);
            c.increment();
            scenario.return_to_sender(c);
        };
        scenario.end();
    }


    
}

