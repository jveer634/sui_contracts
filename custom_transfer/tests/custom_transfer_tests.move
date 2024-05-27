
#[test_only]
module custom_transfer::custom_transfer_tests {
    use sui::test_scenario;
    use custom_transfer::custom_transfer;

    const ENotImplemented: u64 = 0;
    const USER: address = @0xCAFE;
    const ANOTHER_USER: address = @0xFACE;

    #[test]
    fun test_custom_transfer() {
        let mut scenario = test_scenario::begin(USER);
        {
            custom_transfer::init_for_test(scenario.ctx());
        };

        scenario.next_tx(USER);
        {
            let mut ct = scenario.take_from_sender<custom_transfer::CustomTransfer>();
            custom_transfer::new(&mut ct, 10, scenario.ctx());
            scenario.return_to_sender(ct);
        };

        scenario.next_tx(USER);
        {
            let mut ct = scenario.take_from_sender<custom_transfer::CustomTransfer>();
            let asset = scenario.take_from_sender<custom_transfer::Asset>();

            // transfer::public_transfer(asset, ANOTHER_USER);
            
            let counter = custom_transfer::count(&ct, &asset);
            assert!(counter == 0, 0);
            
            custom_transfer::transfer(&mut ct, asset, ANOTHER_USER);
            scenario.return_to_sender(ct);
        };

        scenario.next_tx(USER);
        {
            let ct = scenario.take_from_sender<custom_transfer::CustomTransfer>();
            let asset = scenario.take_from_address<custom_transfer::Asset>(ANOTHER_USER);
            
            let counter = custom_transfer::count(&ct, &asset);
            assert!(counter == 1, 0);
            
            scenario.return_to_sender(ct);
            test_scenario::return_to_address(ANOTHER_USER, asset);
        };
        scenario.end();
    }
}
