# JWT

## Claims

### `iss`

* Issuer. JWTの発行者を示す。

### `sub`

* subject. JWTの対象(用途). 誰を表現しているかを示す理解
* issuer 内でユニーク?

### `aud`

* audience. JWTを検証する人として想定されているコンポーネントの識別子。

### `exp`

* expiration time

### `azp`

意味: Authorized Party（認可された当事者）
用途: クライアントアプリケーションがどのトークンを使用することが許可されているかを指定するため。

### `iat`

* Issued At. いつ発行されたか

### `jti`

* JWT ID. tokenの識別子


## Components

`<header>.<payload>.<signature>`

作成方法は

1. b64url(header_json)とb64url(payload_json)を`.`で連結
2. 電子署名して、`.`で連結

### Header

```json
{
  "typ": "JWT",
  "alg": "HS256"
}
```
をbase64url encodeしたもの

