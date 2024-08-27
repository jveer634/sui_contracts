# Clock_obj

This project contains the move smart contracts to demonstrate using `clock` module and timestamps in our contract.

The `Clock` is a special object shared on the sui network which contains the value of current timestamp in epoch format (milliseconds).

The contracts contains a `Counter` object which can only be updated after a certain time period specified during the object initilization.


The `new` function will create a new Counter object and returns it to the user. We need to pass the time period in milliseconds as 1st parameter and Clock object (0x6 - clock object ID for external calls)

```move
    public entry fun new(time: u64, clock: &Clock, ctx: &mut TxContext) {}
```

The `update` function will take the mutable reference to the user's Counter object reference and reference to the clock object and will update the counter only if the timeperiod is completed. Else will throw an error.

```move
    public entry fun update(counter: &mut Counter, clock: &Clock) {}
```
