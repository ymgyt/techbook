# biome

## Configuration

* `biome init`で`biome.json`を生成できる

```json
{
  "files": {
    "ignore": ["cdk.out"]
  },
  "formatter": {
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 120
  }
}
```


## Format

```sh
biome format . --write
```

* `--write`でfilesystemに書き出す
