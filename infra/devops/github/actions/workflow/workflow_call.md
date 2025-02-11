# workflow_call

* callerのjobから呼ばれる(stepではない)
  * `jobs.<job_id>.uses`
* `github` context はcaller workflowに紐づく
* called workflowは `github.token` と `secrets.GITHUB_TOKEN`にアクセスできる
* callerの`env` contextはcalleeに引き継がれない
* calledのenvもcallerに見えないので、情報を返したい場合はoutputsを使う

* 以下のいずれかの場合、workflowを呼べる
  * callerとcalleeが同じrepository
  * calleeがpublic repoでorgで許可されている
  * calleeがprivateで設定で許可されている
    * Repository > Settings > Actions > General
    * Accessible from repositories owned by ...
      * ここは個人とorgで表記が違う


## Create reusable workflow

* `.github/workflows`以下に定義する
  * `.github/workflows/subdir`はサポートされていない

```yaml
on:
  workflow_call:
    inputs:
      config-path:
        required: true
        type: string
    secrets:
      token:
        required: true

jobs:
  reusable_workflow_job:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/labeler@v4
      with:
        repo-token: ${{ secrets.token }}
        configuration-path: ${{ inputs.config-path }}

```

## caller workflow

```yaml
jobs:
  call-workflow:
    uses: org/repo/.github/workflows/reusable-wf.yaml@main
    permissions:
      id-token: write
      contents: read
      pull-requests: write
    with:
      config-path: "path"
    # secrets: inherit で全部渡すこともできる
    secrets:
      token: ${{ secrets.token }}
```

* `jobs.<job_id>.uses`
  * `{owner}/{repo}/.github/workflows/{workflow}@{ref}`
    * 他repoの場合
  * `./.github/workflows/{filename}`
    * 同じrepoの場合
    * 同じcommitが使われるので、`{ref}`は使えない

* `jobs.<job_id>.permissions`
  * permissionsを指定しないと、default permissionが使われる
  * callee側で必要なpermissionsはcaller側が渡すようにする


### matrix

```yaml

jobs:
  ReuseableMatrixJobForDeployment:
    strategy:
      matrix:
        target: [dev, stage, prod]
    uses: octocat/octo-repo/.github/workflows/deployment.yml@main
    with:
      target: ${{ matrix.target }}
```

* caller側はmatrixでも呼べる


## output

callee 側

```yaml
name: Reusable workflow

on:
  workflow_call:
    # Map the workflow outputs to job outputs
    outputs:
      firstword:
        description: "The first output string"
        value: ${{ jobs.example_job.outputs.output1 }}
      secondword:
        description: "The second output string"
        value: ${{ jobs.example_job.outputs.output2 }}

jobs:
  example_job:
    name: Generate output
    runs-on: ubuntu-latest
    # Map the job outputs to step outputs
    outputs:
      output1: ${{ steps.step1.outputs.firstword }}
      output2: ${{ steps.step2.outputs.secondword }}
    steps:
      - id: step1
        run: echo "firstword=hello" >> $GITHUB_OUTPUT
      - id: step2
        run: echo "secondword=world" >> $GITHUB_OUTPUT
```

caller側

```yaml
name: Call a reusable workflow and use its outputs

on:
  workflow_dispatch:

jobs:
  job1:
    uses: octo-org/example-repo/.github/workflows/called-workflow.yml@v1

  job2:
    runs-on: ubuntu-latest
    needs: job1
    steps:
      - run: echo ${{ needs.job1.outputs.firstword }} ${{ needs.job1.outputs.secondword }}
```
