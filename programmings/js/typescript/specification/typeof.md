# typeof

* valueを引数にとってそのvalueの型を返す
  * value contextの場合
  * jsになってもそのまま生き残る

* type contextではts特有の表現でjsではなくなる

```typescript
if (typeof x === "string") {
  // xをstring型として扱うことをcompilerに許してもらえる
  x.toUpperCase();
}
```

## lookup type

```typescript

const list = ['a', 'b', 'c'] as const; // const assertion

// listはArray<'a' | 'b' | 'c'>
// Array はどうやらnumber 型のpropertyをもつので結果的に要素のunionになる
type NeededUnionType = typeof list[number]; // 'a'|'b'|'c';

```

* `T[K]` で型Tのpropertyの内、型Kを抜き出して、unionする
* [配列から型を生成する](https://typescriptbook.jp/tips/generates-type-from-array)
