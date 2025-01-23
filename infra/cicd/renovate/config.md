# Renovate Configuration

```json5
{
  "extends": ["config:recommended", "helpers:pinGitHubActionDigests"]
  "rangeStrategy": "bump",
  "customManagers": [
    {
      "customeType": "regex",
      "fileMatch": "^Dockerfile$",
      "matchStrings": "ENV FOO_VERSION=(?<currentValue>.*?)\\n"
    }
  ],
  // PR の数の制限
  // Open な renovateによるPRの最大値
  "prConcurrentLimit": 0,
  // 1時間あたりに作られるPRの最大値
  "prHourlyLimit": 0,
  // "schedule"

  // PR をまとめるための設定 後述
  "packageRules": [],
}
```

* `customManagers`: builtin 以外のmanager を指定できる。現状サポートされているのは、`regex` のみ
  * `fileMatch`
  * `matchStrings`

* `rangeStrategy`: 新しいversionに対して既存のfile(Cargo.toml,Cargo.lockとか)をどう更新するか
  * `bump`: 常に`Cargo.toml` も更新する
    * depandabotはこの挙動?

## extend

* `extend`: baseの設定として、preset を指定する
  * 最後にappend された設定が優先される
  * `github>org/repo` で 他のrepositoryの設定を指定できる
    * `github>ymgyt/reno` の場合は、`https://github.com/ymgyt/repo` repository の `default.json` が参照される

* `:semanticCommitTypeAll(chore)`
  * conventional commit でchore の利用を強制
    * 基本はchoreだが、production dependency (cargo の`dependencies`) だと fix を使うのが,`config:recommended` の挙動


## Regex

captureが必須なのは

* `currentValue` dependencyの現在のversion
* `depName` or `packageName`: dependencyの名前
  * 違い https://github.com/renovatebot/renovate/discussions/14885#discussioncomment-2482898
  * `packageName` が空の場合は `depName` が使われる
  * packageの名前が非常に長い場合があるので、そういう時は commit messageの表示を `depName` で指定して、実際のpacakgeを`packageName`で指定する
* `datasource` : datasource の名前
  * inlineで毎回、指示したくない場合は`datasourceTemplate` を使う

```Dockerfile
# renovate: datasource=github-tags depName=node packageName=nodejs/node versioning=node
ENV NODE_VERSION=20.10.0
# renovate: datasource=github-releases depName=composer packageName=composer/composer
ENV COMPOSER_VERSION=1.9.3
# renovate: datasource=docker packageName=docker versioning=docker
ENV DOCKER_VERSION=19.03.1
# renovate: datasource=npm packageName=yarn
ENV YARN_VERSION=1.19.1  
```

```json
{
  "customManagers": [
    {
      "customType": "regex",
      "description": "Update _VERSION variables in Dockerfiles",
      "fileMatch": ["(^|/|\\.)Dockerfile$", "(^|/)Dockerfile\\.[^/]*$"],
      "matchStrings": [
        "# renovate: datasource=(?<datasource>[a-z-]+?)(?: depName=(?<depName>.+?))? packageName=(?<packageName>.+?)(?: versioning=(?<versioning>[a-z-]+?))?\\s(?:ENV|ARG) .+?_VERSION=(?<currentValue>.+?)\\s"
      ]
    }
  ]
}
```

## packageRules

* 複数のruleを定義する
  * ruleは上から適用され、複数matchしたらmergeされる
  * 後に適用されたruleがoverrideする

```json5
{
  "packageRules": [
    {
        "description": "Schedule aws-sdk updates on Sunday nights (9 PM - 12 AM)",
        "matchPackageNames": ["aws-sdk"],
        "schedule": ["* 21-23 * * 0"],
        "enabled": true, // 一時的にdisableにもできる
    }
    {
      "matchFileNames": ["examples/**"],
      "extends": [":semanticCommitTypeAll(chore)"]
    }
  ]
}
```

### PR をまとめる

```json
{
  "packageRules": [
    {
      "groupName": "rust",
      "matchManagers": ["xxx"],
      "matchPackageNames": ["yyy"],
    }
  ]
}
```

* `groupName` が同じpackageの更新は同じPRになる
* matchの条件を書いて、groupを決めていく

## Github 関連の設定

https://docs.renovatebot.com/modules/platform/github/

* renovateが変更するfileのみCODEOWNERから除外することで、CODEOWNERと両立させる方法もあり

```gitignore
src/ @me  
# 後勝ちなので意図的に指定しない
Cargo.* 
```

## PRのassigneesを指定する

* `assignees: ["ymgyt"]`: assignees の指定
* `assigneesFromCodeOwners: <bool>`: CODEOWNER からassigneeを決める
* `assigneesSampleSize: <interger>`: assignees から sample size人 randomにassigneする 
* `expandCodeOwnersGroups: <bool>`: CODEOWNER で指定されているgroup を memberに分解してassigneeする

## preset

extends できる設定集

* `helpers:pinGitHubActionDigests`
  * github action の依存をcommit hash に固定しつつ、コメントでversionを残す
  * 

## rebaseの挙動

* `rebaseWhen`: defaultは`auto`
  * `auto`
    * automergeかrepositoryの設定で、PRを up to dateが設定されていた場合は`behind-base-branch` が使われる
    * それ以外は`conflicted`

  * `never`: manuallyにrequestされない限りなにもしない
  * `conflicted`: conflictした場合のみrebase
  * `behind-base-branch`: base branchが更新されたらrebase

## scheduling

* `timezone: "Asia/Tokyo"`
  * `:timezone(Asia/Tokyo)` presetでもサポートされている

* `schedule`
  * repository単位か、`packageRules` でpackageごとに設定する
  * Granularityは1hour 分はサポートしていない
  * cronとtextのsyntaxをサポート
    * [`croner`](https://www.npmjs.com/package/croner)
    * [`later`](https://github.com/breejs/later)
      * https://breejs.github.io/later/parsers.html#text
  * [preset](https://docs.renovatebot.com/presets-schedule/)

* `automergeSchedule` でautomergeの時間を制限できるが、`platformAutomerge`と併用すると意図どおりにならない可能性があるので注意
  * defaultは`[at any time]`

```
every weekend
before 5:00am
[after 10pm, before 5:00am]
[after 10pm every weekday, before 5am every weekday]
on friday and saturday 

# daily before 4 AM
["* 0-3 * * *"]

# non-office hours
["* 0-4,22-23 * * 1-5", "* * * * 0,6"]
```

* package rule で更新の多いpackage のみ日曜に更新する設定

```json5
{
  "packageRules": [
    {
      "description": "Schedule aws-sdk updates on Sunday nights (9 PM - 12 AM)",
      "matchPackageNames": ["aws-sdk"],
      "schedule": ["* 21-23 * * 0"]
    }
  ]
}
```

## label

* `labels`: renovateがPRに付与するlabel

```json5
{
  "labels": ["dependencies"],
  "packageRules": [
    {
      "matchPackageNames": ["/foo/"],
      "labels": ["linting"] // => ["linting"]
    },
    {
      "matchPackageNames": ["/bar/"],
      "addLabels": ["extra"] // => ["dependencies", "extra"]
    }
  ]
}
```

* `keepUpdatedLabel`: 指定したlabelをPRに付与すると、renovateがrebaseしてbaseに追従してくれる
  * `rebaseWhen`が `never`,`conflicted`の場合に特定のPRを最新にしたい場合に便利

* `stopUpdatingLabel`
  * defaultは`stop-updating`
  * このlabelが付与されているとrenovateはPRを更新しない

## Cache

### Repository

```json
{
  "repositoryCache": "enabled",
  "repositoryCacheType": "s3://some-cache-bucket/dir1/dir2/"
}
```

cache として s3を利用できる

## Reference

* [RenovateのRegex Managerに関する記事](https://gkzz.dev/posts/renovate-regex-manager/)
* [Guide of GitHub Actions and Renovate](https://suzuki-shunsuke.github.io/guide-github-action-renovate)
