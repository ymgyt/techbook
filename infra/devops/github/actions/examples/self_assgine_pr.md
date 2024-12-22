# PR 作成者をAssigneeに指定する

```yaml
# PR 作成者を PR の Assignees に指定する workflow
name: Self Assigne

on:
  workflow_call:

permissions:
  pull-requests: write

jobs:
  assigne:
    runs-on: ubuntu-latest
    timeout-minutes: 5
    if: ${{ ! contains(github.event.pull_request.user.login, '[bot]') && ! contains(github.event.pull_request.user.login, 'internal-tools') && toJSON(github.event.pull_request.assignees) == '[]'}}
    steps:
      - run: >
          gh pr edit
            ${{ github.event.pull_request.number }}
            --repo ${{ github.repository }}
            --add-assignee ${{ github.event.pull_request.user.login }}
        env:
          GITHUB_TOKEN: ${{ github.token }}
```
