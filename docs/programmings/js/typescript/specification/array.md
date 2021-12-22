# array

```typescript
let array1: number[];
array1 = [1, 2, 3];

let array2: Array<number>;
array2 = [1, 2, 3];
```

* どちらも同じ意味

## spread

```typescript
const original = [1, 2, 3];
const copy = [...original];
copy.reverse();

// 追加もできる
const arr = [1, 2, 3];
const arr2 = [...arr, 4];

// 連結
const arr3 = [1, 2, 3];
const arr4 = [4, 5, 6];

const concated = [...arr3, ...arr4];
```
* `[...ident]`でarrayのcopyを作れる

## loop

### for-of

```typescript
const arr = ["a", "b", "c"];
for (const value of arr) {
  console.log(value);
}
```
