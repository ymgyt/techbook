# module

* moduleとは、import or exportを1つ以上含むjs fileのこと
* moduleは常にstrict mode
* 1回目のimportのときだけ評価され、以降はcacheされる

## ES Module

* typescriptではこれ

## CommonJS

```typescript
const pkg1 = require("package1");
```

* serverside(node)で使う場合はこれ
* `require()`を使う
* `.js`,`.ts`を読み込む(`.js`が優先される)
* `node_modules` dir配下に存在する必要がある
  * 呼び出し側のfileからみて相対pathで指定する
* directoryを書いた場合その中の`index.{js,ts}`が読み込まれる

### exports

util.js
```typescript
exports.increment = (i) => i + 1;
```

index.js
```typescript
const util = require("./util");
util.increment(1);

// 分割代入もできる
const { increment } = require("./util");

increment(3);
```


