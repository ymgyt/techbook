# markdown actions

```yaml
name: "Markdown lint"
on: [pull_request]
jobs:
  lint-markdown:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
      - uses: reviewdog/action-markdownlint@v0.26.0
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review
          fail_level: info

```
