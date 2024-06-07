# codecov

## 設定file

* top levelに`codecov.yml`を置く
  * `codecov.yaml`にして`.github/.codecov.yml`からsimlinkをはっても動いた


## `codecov.yml`

```yaml
# https://docs.codecov.com/docs/codecovyml-reference
coverage:
  round: down
  # 赤から黄色の閾値と黄色から緑への閾値
  range: 50..80
  # Pull requestをどう扱うか
  status: # https://docs.codecov.com/docs/commit-status
    project:
      default:
        # 前回より3%カバレッジが落ちないようにする
        target: auto # use the coverage from the base commit 
        threshold: 3% # allow the coverage to drop by
# codecovで無視したいfile
ignore:
  - "crates/synd_term/src/terminal/integration_backend.rs"
  - "crates/synd_test/"
# Pull requestへのbotのcommnetの制御
comment: # https://docs.codecov.com/docs/pull-request-comments
  # 表示するcommentの調整
  # reach is not documented, but validator doesn't complain
  layout: "condensed_header,reach,diff,condensed_files,condensed_footer"
  hide_project_coverage: false
  # coverageに変化があった場合のみcommentを投稿
  require_changes: true
```
