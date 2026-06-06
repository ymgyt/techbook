# prettier

## Install

```sh
# yarn
yarn add --dev --exact prettier

# npm
npm install --save-dev --save-exact prettier
```

## Config

* `.json`や`.js`等いろいろサポートしているらしい

### `prettierrc.js`

```js
module.exports = {
  printWidth: 120,
  tabWidth: 2,
  useTabs: false,
  semi: true,
  singleQuote: true,
  trailingComma: 'all',
  //    {Xxx} 
  // => { Xxx }
  bracketSpacing: true,
  arrowParens: 'always',
  parser: 'typescript',
  overrides: [
    {
      files: '*.json',
      options: {
        parser: 'json',
      },
    },
    {
      files: '*.{yml,yaml}',
      options: {
        parser: 'yaml',
      },
    },
  ],
};
```

## fmt

```shell
# fmt current directory
npx prettier --write .

# fmt target directory
npx prettier --write src/
```

## check

* ciとかでprettier掛かってなかったら失敗させたり
 
```shell
npx prettier --check .
```
