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

## Reference

* [GPG に入門した話](https://qiita.com/kino-ma/items/c5679997293cbbd34b34)
* [GPG最初の一歩](https://tokyodebian-team.pages.debian.net/html2008/debianmeetingresume200803-kansaise4.html)
* [GPG で始める暗号・署名ライフ](https://blog.livewing.net/gpg-life)
  * 鍵の公開の仕方が参考になる
* [](https://www.math.s.chiba-u.ac.jp/~matsu/gpg/index.html)
