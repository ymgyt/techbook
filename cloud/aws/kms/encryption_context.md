# Encryption Context

暗号化時にオプションで渡せる key-value ペア。暗号文に暗号学的に紐付けられる。

## 基本的な動作

```rust
// 暗号化時
let encryption_context = HashMap::from([
    ("purpose".to_string(), "xxx".to_string()),
]);

// 復号時
// → 全く同じ encryption_context を Decrypt に渡す
// → 一致しなければ KMS が InvalidCiphertextException で拒否
```

## 3 つの役割

### 1. 誤用防止 (Additional Authenticated Data)

暗号文に暗号学的に紐付けられる。同じ KMS Key で複数用途の暗号化をしていても、
別の用途の context では復号できない。

```
用途 A の暗号文 + { "purpose": "xxx" } → 復号成功
用途 A の暗号文 + { "purpose": "yyy" } → 復号失敗
```

### 2. 監査 (CloudTrail)

Encryption context は CloudTrail ログに平文で記録される。
誰がどの用途で暗号化/復号したかを追跡できる。

### 3. IAM Policy での条件制御

Key Policy で encryption context の値を条件にアクセス制御できる。

```json
{
  "Condition": {
    "StringEquals": {
      "kms:EncryptionContext:purpose": "device-flow-token"
    }
  }
}
```
