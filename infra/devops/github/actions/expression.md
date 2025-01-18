# Expression

## Functions

* `failure()`
  * previousなstep or jobが失敗していたらtrueを返す
  * job や step で失敗した場合に実行したい時に使える

```yaml
status-check:
    runs-on: ubuntu-latest
    needs:
      - lint
      - test
    permissions: {}
    if: failure()
    steps:
      - run: exit 1
```
