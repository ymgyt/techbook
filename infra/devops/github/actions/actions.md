# Github Actions

## Actions

```yaml
steps:
  - uses: actions/javascript-action@v1.0.1
```

定義されているのは
* public repository
* same repository
* Docker Hubのdocker container

## output parameter


```yaml
jobs:
  foo:
    steps:
    - name: Set color
      id: color-selector
      run: echo "SELECTED_COLOR=green" >> "$GITHUB_OUTPUT"
    - name: Get color
      env:
        SELECTED_COLOR: ${{ steps.color-selector.outputs.SELECTED_COLOR }}
      run: echo "The selected color is $SELECTED_COLOR"
```

* `GITHUB_OUTPUT`に`key=value`のformatで書き込む
* `steps.<id>.outputs.<key>`で参照できる
