# Project Setup

環境構築について。

## Step 

package.jsonを生成する。

```shell
npm init --yes
```

package.jsonに`"type": "module"`を追加する。(一部のfieldのみ表示)

```json
{
  "main": "index.js",
  "type": "module"
}
```

typescriptのinstall

```shell
npm install --save-dev typescript @types/node
```

`tsconfig.json`の生成

```shell
npx tsc --init
```

`tsconfig.json`の変更

```text
"target": "es2020"

"module": "esnext"

"moduleResolution": "node"
```

