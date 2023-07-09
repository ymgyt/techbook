# object

## optional property

```typescript
let x: { width?: number };
x = {};
x = { width: undefined};
// nullはassignできない
// x = { width: null };
```

## excess property checking

* 変数の型より多くのfiledをもつ値をassignできるかという問題
  * object literalではだめ
  * それ以外では許可される

```typescript
const xy: { x: number; y: number } = { x: 1, y: 2 };
let onlyX: { x: number };
onlyX = xy; // OK
```

## index signature

```typescript
let obj: {
  [K: string]: number;
};
obj = {a: 1, b: 2};
obj.c = 3;
```

* `K`のところに使えるのはstring,number,symbolのみ
* `noUncheckedIndexedAccess`を有効にすると、propertyの型が、undefinedとのunionになる

```typescript
const obj: { [K: string]: number } = { a: 1 };
const b: number | undefined = obj.b; // undefined
```

* Recordでも表現できる
```typescript
let obj1: { [K: string]: number };
let obj2: Record<string, number>;
```

## optional chain

```typescript
const book = undefined;
const authorEmail = book?.author?.email;

// 関数呼び出しにも使える
const increment = undefined;
const result = increment?.(1);

// Null合体演算子と組み合わせる
const title = book?.title ?? "default title";
```

* `?.`に先行するvariableやpropertyがnullやundefinedのときはその先が評価されずundefinedが返る
* 得られる値の型は最後のpropertyの型とundefinedのunion

## destructuring assignment

* Rust同様のleft handに型かいて、assignできる
```typescript
const { name, no, genre }: Wild = safari();
```

## object loop

```typescript
const foo = { a: 1, b: 2, c: 3 };
for (const [key, value] of Object.entries(foo)) {
  console.log(key, value);
  // a 1
  // b 2
  // c 3 の順で出力される
}
```
* prototypeのpropertyを無視してくれる

### keyのみ

```typescript
const foo = { a: 1, b: 2, c: 3 };
for (const key of Object.keys(foo)) {
  console.log(key);
  // a
  // b
  // c の順で出力される
}
```
