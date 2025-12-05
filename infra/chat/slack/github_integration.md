# Slack github integration

```sh
# issue, comment, review を subscribeする
# /github subscribe <owner>/<repo> [feature]
/github subscribe ymgyt/repo issues comments reviews

# 状態確認
/github subscribe list features

# 設定変更
/github settings
```

* features
  * `issues`
  * `pulls`
  * `releases`
  * `reviews`
  * `comments`
