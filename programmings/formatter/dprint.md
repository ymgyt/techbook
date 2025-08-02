# dprint

* config file
  * `dprint.json[c]`
  * `.dprint.json[c]`

```sh
# 設定ファイルの作成
dprint init

# pluginの追加
dprint config add dprint/dprint-plugin-typescript

# 更新
dprint config update

# check format
dprint check

# apply format for yaml
dprint fmt **/*.yaml
```

## Configuration

```jsonc
{
  "yaml": {
    "printWidth": 80,
    "quotes": "forceDouble",
    "indentWidth": 2,
    "trailingComma": true,
    "formatComments": true,
    "indentBlockSequenceInMap": true,
    "braceSpacing": true,
    "bracketSpacing": false,
    "preferSingleLine": false,
    "trimTrailingWhitespaces": true,
    "trimTrailingZero": false,
    "ignoreCommentDirective": "pretty-yaml-ignore"
  },
  "excludes": [
    "**/node_modules",
    "**/*-lock.json",
    "**/.terrafomr",
    "pnpm-lock.yaml",
    "infra/grafana/provisioning/**",
    "dev/slack/manifests/**"
  ],
  "plugins": [
    "https://plugins.dprint.dev/g-plane/pretty_yaml-v0.5.1.wasm"
  ]
}
```

## CI

### Actoins

```yaml

- run: |
    curl -fsSL https://dprint.dev/install.sh | sh -s 0.50.0 > /dev/null 2>&1
    echo "/home/runner/.dprint/bin" >> "${GITHUB_PATH}"
  name: Install dprint
- run: dprint check
```
