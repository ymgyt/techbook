# dot

Graphvizのcli。

## Usage

```sh
# dot [flags] [input files]

dot -Tsvg input.dot
echo 'digraph { a -> b }' dot -Tsvg > output.svg

# 解像度の指定
dot -Gdpi=500 -Tpng input.dot

# Formatを指定する
dot -Tsvg
```

* `-T`でformatを指定
  * [supported format](https://graphviz.org/docs/outputs/)
  * svg,png,jpgあたりがある
* `-Gdpi=500`で解像度を指定できる
