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

## 出力parameter

```yaml
jobs:
  release:
    steps:
    - name: Version
      run: echo "::set-output name=version::$(./scripts/print_version.sh)"
      id: version
    - name: Release
      uses: softprops/action-gh-release@v1
      with:
        name: ${{ steps.version.outputs.version }}
```

* stepは何らかの結果をexportできる
* `echo "::set-output name={name}::{value}`がformat
* `${{ steps.{step_id}}.output.{name}`で参照できる
