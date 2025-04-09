# gpg

* GnuPG
* `~/.gnupg` 配下でファイルが管理される

## Usage

```sh
# 生成
gpg  --expert --full-gen-key
gpg --full-generate-key

# 秘密鍵一覧
gpg [-K|--list-secret-keys] --keyid-format=long
gpg --list-keys --keyid-format=long

# export
gpg --armor --export $KEY_ID

# export private key
gpg --export-secret-keys $KEY_ID out> my-private-key.asc
gpg --import my-private-key.asc
gpg --edit-key $KEY_ID
> trust
> 5   （完全に信頼する場合）
> quit

# 公開鍵のexport
gpg --export armor $KEY_ID
```

### Git configuration

```sh

git config --global user.signingkey $KEY_ID

# defaultでsignする
git config --global commit.gpgsign true
git config --global tag.gpgSign true
```

* [参考](https://qiita.com/shun-shobon/items/a944416bebb6207016fb)

### 鍵の生成

```sh
gpg --full-generate-key
gpg (GnuPG) 2.4.5; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (14) Existing key from card
Your selection? 9
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (4) NIST P-384
   (6) Brainpool P-256
Your selection? 1
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 0
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

Real name: ymgyt
Email address: yamaguchi7073xtt@gmail.com
Comment:
You selected this USER-ID:
    "ymgyt <yamaguchi7073xtt@gmail.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: agent_genkey failed: No pinentry
Key generation failed: No pinentry
```

## pinentry

* パスフレーズの安全な入力を担当するcomponent

## Reference

* [GPG に入門した話](https://qiita.com/kino-ma/items/c5679997293cbbd34b34)
* [GPG最初の一歩](https://tokyodebian-team.pages.debian.net/html2008/debianmeetingresume200803-kansaise4.html)
* [GPG で始める暗号・署名ライフ](https://blog.livewing.net/gpg-life)
  * 鍵の公開の仕方が参考になる
* [](https://www.math.s.chiba-u.ac.jp/~matsu/gpg/index.html)
* [GitHubでコミットの署名を必須にする](https://blog.lufia.org/entry/2025/03/16/195658)
