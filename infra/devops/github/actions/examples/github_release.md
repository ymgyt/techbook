# create-gh-release-action

* githubのreleaseを作成できる

## workspaceで複数種類のtagがある場合

```yaml
name: CD
permissions:
  contents: write
on:
  push:
    tags:
      - synd-*
jobs:
  create-api-release:
    runs-on: ubuntu-latest
    if: ${{ startsWith(github.ref, 'refs/tags/synd-api') }}
    steps:
      - uses: actions/checkout@v4
      - uses: taiki-e/create-gh-release-action@v1
        with:
          changelog: crates/synd_api/CHANGELOG.md
          prefix: synd-api
          title: $tag
          token: ${{ secrets.GITHUB_TOKEN }}
```

* `prefix`: tagが`synd-api-v1.2.3`の場合、`synd-api`をprefixとして書いておく
