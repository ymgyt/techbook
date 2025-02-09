# `workflow_run`

```yaml
name: deploy
on:
  workflow_run:
    workflows:
    - "lint"
    - "test"
    branches:
    - main
    types:
    - completed

jobs:
  deploy:
    runs-on: ubuntu-18.04
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    steps:
    - uses: actions/checkout@v2
```

* 他のworkflowのあとにworkflowを実行したいことを表現できる
* branchesの条件はよくわかっていない
* 依存するworkflowの成功を前提にしたい場合はifを書く
* workflow file自体がdefault branch(main)にある必要があるので、feature branchだとうまく動作確認できないかも(理解が曖昧)

