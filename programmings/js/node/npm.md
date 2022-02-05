# npm

## Examples

```console
# 特定のversionをinstall
npm install <package>@v10.1.2

# globalにinstall
npm install -g <package>
```

## Private module

* Githubとか
* `~/.npmrc`を作成して、認証情報を伝える
  * `ymgyt`のところにはgithubのorgがはいる
  * `GH_TOKEN`にはgithubで降り出したaccess tokenを設定する。
    * `repo`と`read:package` scopeが必要
```text
//npm.pkg.github.com/:_authToken=GH_TOKEN
@ymgyt:registry=https://npm.pkg.github.com/
```
