# AWS Encryption SDK (aws-esdk) 概念ガイド

## なぜこんなに複雑なのか

AWS Encryption SDK は「どの鍵で、どうやって暗号化するか」を柔軟に組み合わせられる設計になっている。
その柔軟性のために複数のレイヤーが存在する。

## 全体像

```
┌─────────────────────────────────────────────┐
│ ESDK Client                                 │
│   .encrypt(plaintext, keyring, context)     │
│   .decrypt(ciphertext, keyring, context)    │
│                                             │
│   アプリケーションが直接触る唯一のもの。    │
│   「このデータを暗号化して」と頼む相手。    │
└────────────────┬────────────────────────────┘
                 │ 内部で使う
                 ▼
┌─────────────────────────────────────────────┐
│ Cryptographic Materials Manager (CMM)       │
│                                             │
│   Keyring を使ってデータ鍵を取得し、        │
│   暗号化/復号に必要な「素材一式」を         │
│   ESDK Client に返す。                      │
│                                             │
│   通常は明示的に作らなくてよい。            │
│   Keyring を渡すと ESDK が内部で自動生成。  │
└────────────────┬────────────────────────────┘
                 │ 内部で使う
                 ▼
┌─────────────────────────────────────────────┐
│ Keyring                                     │
│                                             │
│   「データ鍵をどこで生成/暗号化/復号するか」│
│   を決めるもの。                            │
│                                             │
│   種類:                                     │
│   - AWS KMS Keyring      ← 今回使うもの     │
│   - Raw AES Keyring                         │
│   - Raw RSA Keyring                         │
│   - Hierarchical Keyring                    │
│   - Multi-Keyring (複数を組み合わせ)        │
└────────────────┬────────────────────────────┘
                 │ KMS Keyring の場合
                 ▼
┌─────────────────────────────────────────────┐
│ AWS KMS                                     │
│                                             │
│   GenerateDataKey / Decrypt を実行する。    │
│   Keyring が内部で KMS API を呼ぶ。         │
└─────────────────────────────────────────────┘
```

## 各概念の詳細

### ESDK Client

アプリケーションのエントリーポイント。`encrypt()` と `decrypt()` を提供する。

```rust
let esdk_config = AwsEncryptionSdkConfig::builder().build()?;
let esdk_client = esdk_client::Client::from_conf(esdk_config)?;
```

config は暗号化ポリシー (commitment policy) 等を設定するが、
デフォルトで最も安全な設定 (`RequireEncryptRequireDecrypt`) になるので、
builder で何も指定せずに `.build()` するだけでよい。

### Material Providers Client

Keyring を作るための工場 (factory)。Keyring 自体は複雑な内部状態を持つので、
直接 `new()` するのではなく、Material Providers Client の builder メソッドで作る。

```rust
let mpl_config = MaterialProvidersConfig::builder().build()?;
let mpl = mpl_client::Client::from_conf(mpl_config)?;
```

これも config は特に設定不要。工場を作っているだけ。

### Keyring

**最も重要な概念。** データ鍵の生成、暗号化、復号をどこで行うかを決める。

AWS KMS Keyring の場合:

```rust
let kms_keyring = mpl
    .create_aws_kms_keyring()
    .kms_key_id("alias/app-key")  // どの KMS Key を使うか
    .kms_client(kms_client)       // KMS API を呼ぶクライアント
    .send()
    .await?;
```

Keyring は encrypt 時に以下を行う:
1. KMS に `GenerateDataKey` を呼んでデータ鍵を取得
2. 平文データ鍵を ESDK Client に返す (ローカル暗号化に使う)
3. 暗号化されたデータ鍵を ESDK メッセージに埋め込む

Keyring は decrypt 時に以下を行う:
1. ESDK メッセージから暗号化されたデータ鍵を取り出す
2. KMS に `Decrypt` を呼んで平文データ鍵を取得
3. 平文データ鍵を ESDK Client に返す (ローカル復号に使う)

### Cryptographic Materials Manager (CMM)

Keyring と ESDK Client の間にある中間レイヤー。
通常は ESDK が自動的に DefaultCMM を作るので、明示的に触らなくてよい。

CMM の役割:
- Keyring から素材 (データ鍵、署名鍵等) を取得する
- キャッシュ付き CMM を使うと、GenerateDataKey の呼び出しを減らせる
- 今回のユースケースでは不要 (自動生成のデフォルトで十分)

## KmsEncryptor::new() の各行を解説

```rust
pub async fn new(
    kms_client: aws_sdk_kms::Client,
    key_id: &str,
    encryption_context: HashMap<String, String>,
) -> Result<Self, EncryptError> {
    // 1. ESDK Client を作る
    //    「暗号化エンジン」の初期化。設定はデフォルトで OK。
    let esdk_config = AwsEncryptionSdkConfig::builder()
        .build()
        .map_err(|e| EncryptError::Encrypt(e.to_string()))?;
    let esdk_client = esdk_client::Client::from_conf(esdk_config)
        .map_err(|e| EncryptError::Encrypt(e.to_string()))?;

    // 2. Material Providers Client を作る
    //    「Keyring の工場」の初期化。設定はデフォルトで OK。
    let mpl_config = MaterialProvidersConfig::builder()
        .build()
        .map_err(|e| EncryptError::Encrypt(e.to_string()))?;
    let mpl = mpl_client::Client::from_conf(mpl_config)
        .map_err(|e| EncryptError::Encrypt(e.to_string()))?;

    // 3. KMS Keyring を作る
    //    「この KMS Key を使ってデータ鍵を管理する」という設定。
    //    kms_client は KMS API を呼ぶための AWS SDK クライアント。
    let keyring = mpl
        .create_aws_kms_keyring()
        .kms_key_id(key_id)
        .kms_client(kms_client)
        .send()
        .await
        .map_err(|e| EncryptError::Encrypt(e.to_string()))?;

    // esdk_client と keyring を保持。encrypt/decrypt のたびに再利用する。
    Ok(Self {
        esdk_client,
        keyring,
        encryption_context,
    })
}
```

## encrypt/decrypt の流れ

### encrypt

```rust
let response = self.esdk_client
    .encrypt()
    .plaintext(plaintext_bytes)           // 暗号化したいデータ
    .keyring(self.keyring.clone())        // どの鍵で暗号化するか
    .encryption_context(context.clone())  // CloudTrail + AAD
    .send()
    .await?;

let ciphertext: Blob = response.ciphertext.unwrap();
// この ciphertext は ESDK メッセージフォーマット。内部に以下を含む:
// - ヘッダ (アルゴリズム、暗号化されたデータ鍵、encryption context)
// - ボディ (AES-GCM で暗号化されたデータ)
// - フッタ (署名)
```

ESDK が内部で行っていること:
1. Keyring 経由で KMS GenerateDataKey → 平文データ鍵 + 暗号化データ鍵
2. 平文データ鍵で AES-GCM 暗号化 (nonce 生成も ESDK が行う)
3. ESDK メッセージフォーマットにパック (ヘッダ + 暗号化データ鍵 + 暗号文)
4. 平文データ鍵をメモリから消去

### decrypt

```rust
let response = self.esdk_client
    .decrypt()
    .ciphertext(ciphertext)               // encrypt で得た ESDK メッセージ
    .keyring(self.keyring.clone())        // 復号に使う鍵
    .encryption_context(context.clone())  // 一致しないと失敗
    .send()
    .await?;

let plaintext: Blob = response.plaintext.unwrap();
```

ESDK が内部で行っていること:
1. ESDK メッセージをパース → 暗号化データ鍵 + 暗号文を取り出す
2. Keyring 経由で KMS Decrypt → 平文データ鍵を取得
3. 平文データ鍵で AES-GCM 復号
4. encryption context の検証 (一致しなければ失敗)
5. 平文データ鍵をメモリから消去

## Keyring の種類 (参考)

| Keyring | 鍵の置き場所 | 用途 |
|---------|-------------|------|
| AWS KMS Keyring | AWS KMS | 最も一般的。今回使う |
| Raw AES Keyring | アプリが鍵を直接保持 | テスト、KMS 不要な環境 |
| Raw RSA Keyring | 公開鍵/秘密鍵ペア | クロスプラットフォーム |
| Hierarchical Keyring | KMS + DynamoDB | 鍵キャッシュ。高頻度向け |
| Multi-Keyring | 複数の Keyring を組み合わせ | 鍵の冗長化、移行 |

