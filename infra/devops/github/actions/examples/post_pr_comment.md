# Post PR Comment

workflowのコマンドの実行結果をPRのコメントとしてフィードバックしたい


```yaml
jobs:
  plan:
    permissions:
      contents: read
      # For posting terraform output to PR
      pull-requests: write
    steps:
      - name: terraform plan
        id: plan
        continue-on-error: true
        run: terraform plan
      - name: Post plan output to github PR
        uses: actions/github-script@v7
        env:
          PLAN_RESULT: ${{steps.plan.outcome}}
          PLAN_STDOUT: ${{steps.plan.outputs.stdout}}
        with:
          script: |
            const { PLAN_RESULT, PLAN_STDOUT } = process.env

            const body = `terraform plan: ${PLAN_RESULT}
            <details>
              <summary>plan output</summary>
              \`\`\`
              ${PLAN_STDOUT}
              \`\`\`
            </details>`

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body,
            })
```
