# Encode and Decode

## base64

```nu
'U29tZSBEYXRh' | decode base64

# decode -> binary -> utf-8でとりだせる
"aaa" | encode base64 | decode base64 | decode utf-8
aaa
```
