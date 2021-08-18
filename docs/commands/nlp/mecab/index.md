# Mecab

## Install

mecabのinstall
```shell
# source 
# https://taku910.github.io/mecab/#download

tar zxvf mecab-0.996.tar.gz
cd mecab-0.996
./configure
make 
make check
sudo make install
macab --version
```

辞書のinstall

```shell
tar zxfv mecab-ipadic-2.7.0-XXXX.tar.gz
cd mecab-ipadic-2.7.0-XXXX
./configure
make
sudo make install
```

### Mac

公式からmakeでinstallすると文字化けするので、brewでいれる

```sehll
brew install mecab mecab-ipadic
```

## Usage

```shell
# 出力をわかち書きにする
mecab -O wakati

```
