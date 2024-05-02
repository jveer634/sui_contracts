# Soul Bound Object

Soul bound objects are the objects that are directly created for the user but can't be transferred. These are useful where we are creating objects that either represent real world assets like Certificates, Awards etc which are once given to a user, they are not suppoused to be transferred. Another use case is when we are creating identifier objects for a user to our ecosystem.

The Soul Bound Objects are a regular NFT objects without `store` capability. The store capability allows the object to be stored on the blockchain and they allow to transfer using `public_transfer` method.

But without store, objects can be transferred only using `transfer` method and this method can only transfer objects created on that module itself only.

The source code contains 2 modules.

1. Registry - which will generate new AuthProxy (SBO) for the users.
2. Counter - A counter contract which will create new counters by users with AuthProxy.

To extend the auth proxy, we can add more fields to the object such as `is_active`, `is_staff` etc., like given below

```move
    public struct AuthProxy has key {
        id: UID,
        is_active: bool,
        is_staff: bool
    }
```
