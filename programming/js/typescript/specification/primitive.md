# primitive

* propertyをもたない
  * `null.toString()`みたいなことはできない
  * autoboxingされると、primitiveがobjectになる
    * `name.length`

## primitiveの種別

* boolean
  * `true` or `false`
* number
  * `1`や`0.2`
* string
* undefined
* null
* symbol
* bigint

### number

* `Nan`
* `Infinity`

### string

#### template literal

```typescript
const count = 100;
console.log(`current count: ${count}`); // => current count: 100
```

### null

* `typeof null`で`"object"`が返ってくる


### undefined

```typescript
let name;
console.log(name);

function func() {}
console.log(func());

const obj = {};
console.log(obj.name);

const arr = [];
console.log(arr[1]);
```

* 変数が未初期化
* 戻り値のない関数の戻り値
* objectに存在しないproperty
* 配列に存在

