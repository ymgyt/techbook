# depandabot

```yaml
# https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file
version: 2
updates:
  - package-ecosystem: github-actions
    # directoryは"/"である必要があるらしい
    directory: /
    schedule:
      interval: monthly # weekly
      day: "monday"
      time: "11:00"
      timezone: "Asia/Tokyo"
    reviewers:
      - "me"
      - "@ymgyt/bar"

  - package-ecosystem: cargo
    directory: /
    schedule:
      interval: monthly
```

```yaml

version: 2
updates:
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: weekly
      time: "07:00"
      timezone: "Asia/Tokyo"
    labels: ["kind/dependencies", "area/github_actions"]
  - package-ecosystem: cargo
    directory: /
    schedule: # github does not support yaml anchors
      interval: weekly
      time: "07:00"
      timezone: "Asia/Tokyo"
    labels: ["kind/dependencies", "area/rust"]
    # https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file#groups
    # If a dependency doesn't belong to any group, Dependabot will continue to raise single pull requests to update the dependency to its latest version as normal.
    groups:
      opentelemetry:
        applies-to: version-updates
        patterns: ["opentelemetry*"]
      rust-patch:
        applies-to: version-updates
        update-types: ["patch"]
```

* `version: 2`: 固定で必須
* `updates`: 必須
  * `schedule`
    * `interval`: monthly, weekly, daily
    * `time`: 何時に実行するか
    * `timezone`: `Asia/Tokyo`のように指定できる
    * `day`: "monday"
  * `labels`: defaultでは、dependenciesと、package-ecosystemのlabelを付与
    * 存在しないlabelを指定すると無視される
  * `groups`: 原則は1 dependencyごとに1 PRが作成される
    * `<group_name>`
      * `applies-to`: defaultは、version-updates, securityもあり、両方は指定できない
      * `patterns`: dependencyのpatterns
      * `update-types`: patch, minor, majorで分類

