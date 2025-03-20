# fontconfig

* `/etc/fonts/fonts.conf` に設定がある
* commands
  * `fc-conflist` 設定のlist
  * `fc-cache`
  * `fc-match`

## fc-list

* fontを検索


## fc-cache

```sh
fc-cache --really-force
```

## fc-match

```sh
fc-match 'Noto Sans'
```

## Ubuntu font install

```sh
sudo apt-get update
sudo apt-get install -y fonts-noto-cjk fontconfig wget
wget -O HaranoAjiFonts.tar.gz -nv https://github.com/trueroad/HaranoAjiFonts/archive/refs/tags/20231009.tar.gz
mkdir -p ~/.local/share/fonts
tar -xzf ./HaranoAjiFonts.tar.gz -C ~/.local/share/fonts
fc-cache -fv
```
