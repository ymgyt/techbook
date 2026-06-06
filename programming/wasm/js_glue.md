# Js Glue code

JavaScriptからWASMを使う。


## Memo

```js
WebAssembly.compileStreaming(fetch('{{ get_url(path='/wasm/hellolog.wasm') }}'))
  .then(function(mod) {
    let imports = WebAssembly.Module.imports(mod);
    console.log(imports[0]);
    let exports = WebAssembly.Module.exports(mod);
    console.log(exports);
  });
```

```js
(async () => {
  const fetchPromise = fetch(url);
  const { instance } = await WebAssembly.instantiateStreaming(fetchPromise);
  // Use the module
  const result = instance.exports.method(param1, param2);
  console.log(result);
})();
```