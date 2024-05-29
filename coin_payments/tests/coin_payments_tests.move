
#[test_only]
module coin_payments::coin_payments_tests {
    use sui::coin;
    use sui::sui::SUI;
    use sui::test_scenario;
    use coin_payments::coin_payments;

    const USER: address = @0xFACE;
    const ADMIN: address = @0xCAFE;

    #[test]
    fun test_coin_payments() {
        let mut scenario = test_scenario::begin(ADMIN);
        {
            coin_payments::init_for_testing(scenario.ctx());
        };

        scenario.next_tx(USER);
        {
            let mut cp = test_scenario::take_shared<coin_payments::CoinPayments>(&scenario);

            let c = coin::mint_for_testing<SUI>(1000, scenario.ctx());

            coin_payments::new(&mut cp, c, scenario.ctx());

            test_scenario::return_shared(cp);
        };

        scenario.next_tx(USER);
        {
            let mut cp = test_scenario::take_shared<coin_payments::CoinPayments>(&scenario);
            let c = coin::mint_for_testing<SUI>(100, scenario.ctx());

            let mut counter = scenario.take_from_sender<coin_payments::Counter>();
            coin_payments::increment(&mut counter, &mut cp, c);

            scenario.return_to_sender(counter);
            test_scenario::return_shared(cp);
        };

        scenario.next_tx(ADMIN);
        {
            let mut cp = test_scenario::take_shared<coin_payments::CoinPayments>(&scenario);
            let cap = scenario.take_from_sender<coin_payments::CoinPaymentsCap>();

            coin_payments::withdraw(&mut cp, &cap, scenario.ctx());

            scenario.return_to_sender(cap);
            test_scenario::return_shared(cp);
        };

        scenario.end();
    }
}
