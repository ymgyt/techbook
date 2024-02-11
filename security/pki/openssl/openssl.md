# openssl

* `openssl version -a`で詳細な情報みれる
  * ここで`OPENSSLDIR`を確認できる

## Private key

### 生成

```shell
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 > private_key.pem
```

* `genpkey` 秘密鍵を生成するsubcommand
  * `genrsa`,`gendsa`もあるがgenpkey推奨らしい
* `-algorithm EC` 楕円曲線(Ellpptic Curve)
  * `-pkeyopt`より前におく必要あり
* `-pkeyopt ec_paramgen_curve:P-256`
  * 楕円曲線アルゴリズム固有のparameter
* 参照 https://qiita.com/TakahikoKawasaki/items/4c35ac38c52978805c69#41-openssl-%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89

### 表示

```sh
openssl pkey -text -noout -in private_key.pem
```

* `pkey` 鍵に関する処理のsub command
* `-text` plain textで表示
* `-noout` 鍵自体は表示しない
* `-in` input fileを指定

### Private keyから公開鍵を抽出

```sh
openssl pkey -pubout -in private_key.pem > public_key.pem
```

## 自己証明書

```sh
# 生成
openssl req -x509 -key private_key.pem -subj /CN=ymgyt.io -days 365 > certificate.pem

# 確認
openssl x509 -text -noout -in certificate.pem
```

* `req -x509` reqはCSRを生成するが、`-x509`をつけると自己証明書になる
* `-key` 署名に使う秘密鍵、証明の対象となる公開鍵を指定する
  * private keyには公開鍵の情報も含まれている
* `-subj` subject(主体者)を指定する
  * issuerもこの値になる
* `-days` 有効期間を指定する。defaultは30日
* SANはどうやって指定する..?



## Certificate Sign Request

拡張用の設定file(`csr.ext`)を作成する

```text
subjectAltName = DNS:*.ymgyt.io, DNS:ymgyt.io
```

```shell
# 生成
openssl req -new -key ymgyt.key -subj "/CN=ymgyt" -extfile csr.ext -out csr.pem

# 表示
openssl req -text -noout -in csr.pem
```

* SAN(Subject Alternate.. Name)はどうやって入力する?
