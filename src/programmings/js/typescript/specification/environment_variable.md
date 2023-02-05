# Environment variable

```typescript
const v = process.env.ENV_KEY ?? "default"
```

* `process.env` objectに入っている。
  * 設定されていない場合はobjectに対する存在しないproperty accessとしてundefinedが返る
