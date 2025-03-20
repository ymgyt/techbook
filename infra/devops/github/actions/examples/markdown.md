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


## Convert markdown to pdf

```yaml
name: "Example"
on:
  push:
    branches:
      - main
jobs:
  publish-policies:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
      - name: Install pandoc
        uses: pandoc/actions/setup@v1.1.0
        with:
          version: 3.6.3
      - name: Install typst
        uses: taiki-e/install-action@v2
        with:
          tool: typst-cli@0.13.1
      - name: Install fonts
        run: |
          sudo apt-get update
          sudo apt-get install -y fonts-noto-cjk
      - name: Convert to pdf
        run: typst commands...
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```
