# Cache Header

## 概要

HTTP cache は、レスポンスの再利用を制御する仕組み。  
考えるべきことは大きく 4 つある。

1. 保存してよいか
2. どこに保存してよいか
3. いつそのまま再利用してよいか
4. 再利用前にどう再検証するか

この文書では、cache を次の 3 層に分けて整理する。

- メンタルモデル
  - cache をどう分解して考えるか
- 要素リファレンス
  - header / directive / status code の意味
- ユースケース
  - 実際の組み合わせ方

---

## メンタルモデル

### 保存と再利用は別

HTTP cache では、まず次を分けて考える。

- 保存してよいか
- 保存済みレスポンスをそのまま使ってよいか

保存を許可していても、再利用前に毎回確認させることがある。  
逆に、一定時間は確認なしで使わせることもある。

---

### cache には場所がある

cache は browser だけではない。

- browser の private cache
- proxy や CDN の shared cache

したがって、cache では「保存可否」だけでなく「保存場所」も重要になる。

---

### fresh と stale

保存済みレスポンスは概念的に 2 状態で考える。

- fresh
  - そのまま再利用してよい
- stale
  - そのまま使わず、再検証が必要

`Cache-Control` は主に fresh / stale の扱いを決める。  
`ETag` は stale になった後の再検証の鍵になる。

---

### policy と validator

HTTP cache の要素は大きく 2 種類ある。

- policy
  - 保存や再利用のルール
- validator
  - 手元のレスポンスがまだ有効か判定する材料

例:

- policy
  - `Cache-Control`
- validator
  - `ETag`
  - `Last-Modified`

---

### 再検証の流れ

再検証は概ね次の流れで起きる。

1. クライアントがレスポンスを保存する
2. 次回アクセス時に、そのまま使えるか policy を見る
3. そのまま使えなければ validator を使って再検証する
4. 変わっていなければ `304 Not Modified`
5. 変わっていれば新しい `200 OK` を受け取る

---


## Cache-Control

`Cache-Control` は、保存と再利用の policy を表す header。

### 役割

- 保存してよいか
- どこに保存してよいか
- いつまで fresh か
- stale の扱いをどうするか

### 注意

`Cache-Control` 自体は再検証の比較値を持たない。  
比較そのものは `ETag` や `Last-Modified` が担う。

### directives

#### private

```http
Cache-Control: private
````

* private cache には保存してよい
* shared cache では共有しない

主に「保存場所」を制御する directive。

---

#### public

```http
Cache-Control: public
```

* shared cache を含めて保存してよい

主に「保存場所」を制御する directive。

---

#### must-revalidate

```http
Cache-Control: must-revalidate
```

* stale になったレスポンスを勝手に再利用しない
* 再利用前に origin に確認する

主に「stale の扱い」を制御する directive。

---

#### max-age

```http
Cache-Control: max-age=300
```

* 300 秒のあいだ fresh
* その間は確認なしで再利用してよい

主に「fresh 期間」を制御する directive。

---

#### no-store

```http
Cache-Control: no-store
```

* 保存しない

cache 自体を禁止する directive。

---

#### no-cache

```http
Cache-Control: no-cache
```

* 保存はしてよい
* ただし再利用前に再検証する

名前と違って「cache 禁止」ではない点に注意。

---

## ETag

```http
ETag: "abc123"
```

### 役割

レスポンス表現の validator。
クライアントが持っている内容と server 側の内容が同じかどうかを判定するための識別子。

### ポイント

* policy ではない
* 保存可否や fresh 期間は決めない
* 再検証の鍵になる

---

## If-None-Match

```http
If-None-Match: "abc123"
```

### 役割

クライアントが手元の `ETag` を送って再検証するための request header。

### 振る舞い

* 一致すれば `304 Not Modified`
* 不一致なら `200 OK` と新しい body

---

## 304 Not Modified

```http
304 Not Modified
```

### 役割

再検証の結果、手元の cached response がまだ有効であることを示す status code。

### 効果

* body を再送しない
* クライアントは手元の body を再利用する

---

## ユースケース

### 保守的な browser cache

```http
Cache-Control: private, must-revalidate
ETag: "abc123"
```

意味:

* browser には保存してよい
* shared cache には載せない
* 再利用前に毎回確認する
* 確認には `ETag` を使う

correctness 優先の構成。

---

### 少し性能寄り

```http
Cache-Control: private, max-age=300
ETag: "abc123"
```

意味:

* browser に保存してよい
* 5 分間はそのまま再利用してよい
* 期限後に `ETag` で再検証する

latency を少し優先する構成。

---

### cache を使わない

```http
Cache-Control: no-store
```

意味:

* 保存しない
* 再検証以前に cache を無効化する

