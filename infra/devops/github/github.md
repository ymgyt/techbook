# Github

## Release

* Draftは作った人?にしか見えず、publicでない
* Prereleaseはexcuse的な意味があるだけで他は変わらない


## CodeOwners


```text
# https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners

* @org/dev
```


* `.github/CODEOWNERS`に配置する
* `.gitignore`形式でfileをあてて、誰がownerかを指定する
  * 個人の場合は`@ymgyt`
  * teamの場合は、`@org/dev` (organizationのteamに識別子書いてある)
    * 当該repositoryにwrite権限が付与されている必要がある
