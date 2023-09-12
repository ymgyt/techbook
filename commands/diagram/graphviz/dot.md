# dot

Graphvizのcli。

## Usage

```sh
# dot [flags] [input files]

dot -Tsvg input.dot
echo 'digraph { a -> b }' dot -Tsvg > output.svg

# Formatを指定する
dot -Tsvg
```

* `-T`でformatを指定
  * [supported format](https://graphviz.org/docs/outputs/)
  * svg,png,jpgあたりがある
