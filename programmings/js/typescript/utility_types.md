# Utility Types

tsが提供してくれているbuiltin型。  
https://www.typescriptlang.org/docs/handbook/utility-types.html

## `Partial<T>`

`T`のpropertiesをすべてoptionalにした型を返す。

## `Record<Keys, Type>`

* HashMap型をつくれる
```typescript
let x: Record<string,number>;
x = {f1: 1, f2: 2};
```
