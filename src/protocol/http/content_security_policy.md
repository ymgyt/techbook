# Content Security Policy

CSPについて。


## CSPの適用

* `Content-Security-Policy: <policy-directive>; <policy-directive>` headerをserverが返す。
  * `<policy-directive>`は`<direvtive> <value>`


## Directive

### Fetch directive

特定のresouceを読み込むことができる場所を制御する

* `default-src`
  * 他のdirectiveがない場合のdefault値


## Example

```
default-src 'none'; 
img-src blob: 'self' data: 'unsafe-inline' 'unsafe-eval';
script-src 'self' 'unsafe-inline' 'unsafe-eval' wasm-eval;
script-src-elem 'self' 'unsafe-inline' 'unsafe-eval'; 
style-src 'self' 'unsafe-inline'; 
object-src 'self'; 
media-src 'self'; 
connect-src 'self' https://example.com/; 
base-uri 'self'; 
child-src 'self' wyciwyg:; 
font-src 'self'
```