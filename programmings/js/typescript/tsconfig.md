# tsconfig.json

```json
// 暗黙のanyをcompile errorにする
"noImplicitAny": true

// index object { [K: string]: number }
// のpropertyの型が number | undefinedとして扱われる
// arrayのindex accessでも同様に扱われる
"noUnchkedIndexedAccess": true


```
