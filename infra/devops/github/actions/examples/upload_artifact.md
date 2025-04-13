# Upload Artifact

* job-a で なにかbuildして、job-bから参照したりできる

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@main
      - run: build artifacto --somehow

      - name: upload extension
        uses: actions/upload-artifact@v4
        with:
          name: foo
          path: path/to/artifact
          # 見つからなかったらエラーにする
          if-no-files-found: error
          retention-days: 1
          overwrite: true
          # upload 対象がgitignore されていても見つける
          include-hidden-files: true

  release:
    runs-on: ubuntu-latest
    if: startsWith(github.ref, 'refs/tags/')
    needs: "build"
    steps:
      - uses: actions/checkout@main

      - name: download extension
        uses: actions/download-artifact@v4
        with:
          name: foo
          path: ./

      - name: create github release
        uses: ncipollo/release-action@v1
        with:
          artifacts: 'artifact-*.ext'
          allowUpdates: true
          artifactErrorsFailBuild: true
          replacesArtifacts: true
```

* `download-artifact`
  * `pattern`: download対象をglobで指定できる
    * `result-*`
  * `merge-multiple`: artifactをdirectoryごとに分けずに、1つのdirectoryにまとめる

