# npm

## Examples

```console
# 特定のversionをinstall
npm install <package>@v10.1.2

# localのpackageをinstall
npm install ../path/lib/other

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

### Dockerfile内でのinstall

Dockerfile内で`{yarn,npm} install`うつ場合はbuild contextに`.npmrc`を含めるように注意。  
多分yarnも`.npmrc`を参照してくれているっぽい。


## Dependency

* private git repositoryを依存に加える
  * `npm install git@github.com:ymgyt/foo.git`
  * たぶん、`.npmrc`に認証情報がいる
