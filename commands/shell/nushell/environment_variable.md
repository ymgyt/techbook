# Nushell Environment Variable

## 設定

```nu
load-env { K1: "v1", K2: "v2"}
```

これをfileに書いて、`source`すると現在のsessionに反映できる

```nu
# sessionに設定
$env.AWS_REGION = "ap-northeast-1"
```

## Load

```sh
# 直近の終了code
$env.LAST_EXIT_CODE
```

