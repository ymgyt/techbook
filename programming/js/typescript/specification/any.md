# any type

* 何でもassignできる

```typescript
let x: any;
x = 1; // OK
x = "string"; // OK
x = { name: "オブジェクト" }; // OK
```

## implicit any

```typescript
function ok(arg) { }
```

* `arg`の型は`any`になる
* tsconfig.jsonの`noImplicitAny: true`を指定すると、compile時にerrorにできる
