/// Module: clock_obj
module clock_obj::clock_obj {

    use sui::clock::Clock;

    public struct Counter has key, store {
        id:UID,
        count: u64,
        time: u64,
        last_updated: u64
    }


    public entry fun new(time: u64, clock: &Clock, ctx: &mut TxContext) {
        transfer::transfer(Counter {
            id: object::new(ctx),
            count: 0,
            time: time,
            last_updated: clock.timestamp_ms()
        }, ctx.sender());
    } 

    public entry fun update(counter: &mut Counter, clock: &Clock) {
        assert!(counter.last_updated + counter.time <= clock.timestamp_ms(), 0);
        counter.count = counter.count + 1;
        counter.last_updated = clock.timestamp_ms();
    }

}
