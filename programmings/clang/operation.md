# Operation

* `n--`は`n`を参照したのち、nを減算する

```c
void *memcpy(void *dst, const void *src, size_t n) {
    uint8_t *d = (uint8_t *) dst;
    const uint8_t *s = (const uint8_t *) src;
    while (n--)
        *d++ = *s++;
    return dst;
}
```

## 代入とincrement

`*p++ = c`は


```c
*p = c;
p = p + 1;
```
のように代入したのち、加算を表現している
