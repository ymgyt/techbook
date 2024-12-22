# Renovate Configuration

```json
{
  "extends": ["config:recommended", "helpers:pinGitHubActionDigests"]
  "customManagers": [
    {
      "customeType": "regex",
      "fileMatch": "^Dockerfile$",
      "matchStrings": "ENV FOO_VERSION=(?<currentValue>.*?)\\n"
    }
  ]
}
```

* `extend`: baseの設定として、preset を指定する
  * 最後にappend された設定が優先される
  * `github>org/repo` で 他のrepositoryの設定を指定できる
    * `github>ymgyt/reno` の場合は、`https://github.com/ymgyt/repo` repository の `default.json` が参照される

* `customManagers`: builtin 以外のmanager を指定できる。現状サポートされているのは、`regex` のみ
  * `fileMatch`
  * `matchStrings`


## Regex

captureが必須なのは

* `currentValue` dependencyの現在のversion
* `depName` or `packageName`: dependencyの名前
  * 違い https://github.com/renovatebot/renovate/discussions/14885#discussioncomment-2482898
  * `packageName` が空の場合は `depName` が使われる
  * packageの名前が非常に長い場合があるので、そういう時は commit messageの表示を `depName` で指定して、実際のpacakgeを`packageName`で指定する
* `datasource` : datasource の名前

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

## Reference

* [RenovateのRegex Managerに関する記事](https://gkzz.dev/posts/renovate-regex-manager/)
