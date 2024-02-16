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
