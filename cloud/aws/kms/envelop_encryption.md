# Envelope Encryption

KMS の `Encrypt` API は直接暗号化できるデータサイズに制限がある:

| 鍵タイプ             | 最大平文サイズ |
|----------------------|----------------|
| 対称鍵 (AES-256)     | 4,096 bytes    |
| RSA-2048 OAEP-SHA256 | 190 bytes      |


## Envelope Encryption の仕組み

2 層の暗号化:

* APIのレスポンスで２つの情報を返す
  * 暗号化用の使い捨てkey(plain text)
  * 復号化用の暗号化済key
    * 暗号化データと一緒に埋め込む
    * 復号時にKMS Decrypt APIでdecryptして復号化する

KMS は小さなデータ鍵だけを暗号化/復号する。実際のデータの暗号化はアプリケーションがローカルで行う。

## GenerateDataKey の動作

```
アプリケーション                         AWS KMS
    │                                       │
    │── GenerateDataKey ─────────────────→  │
    │     KeyId: "alias/idpstack-token-key" │
    │     KeySpec: AES_256                  │
    │                                       │ 1. ランダムな 256-bit 鍵を生成
    │                                       │ 2. その鍵を現在の HBK で暗号化
    │                                       │
    │ ←── レスポンス ───────────────────────│
    │   Plaintext: <生の 32 bytes>          │
    │   CiphertextBlob: <約 200 bytes>      │
    │   KeyId: <KMS Key ARN>                │
    │                                       │
    │ 3. Plaintext でデータを AES-GCM 暗号化│
    │ 4. Plaintext をメモリから消去         │
    │ 5. CiphertextBlob + 暗号文を保存      │
```

- `Plaintext`: 生のデータ鍵 (32 bytes for AES_256)。暗号化に使ったら即消去
- `CiphertextBlob`: KMS Key で暗号化されたデータ鍵 (約 200 bytes)。保存する
- `KeyId`: 使用された KMS Key の ARN

## 復号フロー

```
アプリケーション                         AWS KMS
    │                                         │
    │ 1. DB から CiphertextBlob + 暗号文を読む│
    │                                         │
    │── Decrypt(CiphertextBlob) ─────────→    │
    │                                         │ 2. CiphertextBlob のメタデータから
    │                                         │    KMS Key + HBK バージョンを特定
    │                                         │ 3. 正しい HBK で復号
    │                                         │
    │ ←── レスポンス ─────────────────────    │
    │   Plaintext: <生の 32 bytes>            │
    │                                         │
    │ 4. Plaintext で暗号文を AES-GCM 復号    │
    │ 5. Plaintext をメモリから消去           │
```

**重要**: Decrypt 時に KMS Key ID の指定は不要 (省略可)。CiphertextBlob 自体にどの鍵で暗号化されたかの情報が含まれている。
指定する場合は「期待する鍵であることの検証」として機能する。

## GenerateDataKey vs GenerateDataKeyWithoutPlaintext

|                       | GenerateDataKey  | GenerateDataKeyWithoutPlaintext  |
|-----------------------|------------------|----------------------------------|
| Plaintext を返す      | Yes              | No                               |
| CiphertextBlob を返す | Yes              | Yes                              |
| 用途                  | 今すぐ暗号化する | 後で別コンポーネントが暗号化する |
