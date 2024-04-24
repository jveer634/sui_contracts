# Counter

This project contains the move smart contracts for the Counter smart contract.

The `Counter` object contains only one attribute called `val` which has the counter value.

The `new` function will create a new Counter object and returns it to the user.

```move
    public fun new(ctx: &mut TxContext): Counter {}
```

The `increment` function will take the mutable reference to the user's Counter object reference and will update the counter value.

```move
    public fun increment(c: &mut Counter) {}
```

The `decrement` function is used to the decrement the value of the counter by passing mutable reference of the Counter. This function also contains a check to prevent decrement to negative number.

```move
    public fun decrement(c: &mut Counter) {}

```
