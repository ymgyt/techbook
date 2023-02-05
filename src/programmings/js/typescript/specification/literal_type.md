# literal type

* primitive型の特定の値だけを代入にする型を表現できる。

```typescript
// xにはなんでもassigneできる
let x: number;
x = 1;
```

```typescript
// xには1だけを代入できる
let x: 1
x = 1;

// compile error
// x = 2;
```

## literal typeが利用できるprimitive型

* bool
* number
* string

```typescript
let status: 1 | 2 | 3 = 1;


```
