# Alacritty

## install

### srcからbuildする

```
git clone https://github.com/alacritty/alacritty
cd alacritty/alacritty
git checkout <version>

cargo install --path . --force
```

### macOS

```
make app
cp -r target/release/osx/Alacritty.app /Applications/
```


## config

githubのreleaseに含まれている。  

* `$HOME/.config/alacritty/alacritty.yml`に置いておく。
* `$HOME/.alacritty.yml` もみにいってくれる。

最近tomlにかわったぽい。  

## debug

`alacritty --print-events`でkey eventを表示してくれるのでうまくいかない際に便利
