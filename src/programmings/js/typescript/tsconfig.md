# tsconfig.json

## `compilerOptions`

```text
// 暗黙のanyをcompile errorにする
"noImplicitAny": true

// index object { [K: string]: number }
// のpropertyの型が number | undefinedとして扱われる
// arrayのindex accessでも同様に扱われる
"noUnchkedIndexedAccess": true

// 生成されるjavascriptの仕様(version)を決める
"target": "es2020"

// moduleに関連する挙動を制御        
"module": "esnext"

// node.js使う前提ならnodeでよい
"moduleResolution": "node"

// typescript -> jsの出力結果の保存先
"outDir": "./dist"
```

## toplevel

```text
// tsのcompile対象の指定
"include": ["./src/**/*.ts"]
```
