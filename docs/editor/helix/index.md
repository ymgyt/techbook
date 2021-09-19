# helix

## Install

sourceからbuildする
```shell
git clone --recurse-submodules --shallow-submodules -j8 https://github.com/helix-editor/helix
cd helix
cargo install --path helix-term
```

## Config

`~/.config/helix/config.toml`

## Usage

### Registers

`"a` とすると`a`Registerを選択する
```shell
# yank current selection to register a
"ay

# paste the text in register o
"op

# m registerにstoreしつつdelete
"md

# h registerにstoreしつつchange
"hc
```




