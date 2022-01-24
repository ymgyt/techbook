# variable 

## const
```typescript
const x: number = 1;
```

* 再代入できない
* 基本`const`を使う

## let

```typescript
let x: number = 1;
x = 2;
```

* 再代入できる

## var

* 使わない
* global変数として利用すると、暗黙的に`window`objectのpropertyとして扱われる。
* 巻き上げやscopeが直感的でない
