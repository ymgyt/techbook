# ngrok

## Install

```sh
NIXPKGS_ALLOW_UNFREE=1 nix profile add --impure nixpkgs#ngrok

# tokenはngrok UIに表示される
ngrok config add-authtoken [REDACTED]
```

## Proxy

1. localでserverを起動する
    * endpointが`http://localhost:1234/webhook/foo` とする

2. ngrokを起動

  ```sh
  # URLが表示される
  ngrok http 1234
  # => https://xxx.ngrok-free.app
  ```

3. Webhook先URLを設定する

  `https://xxx.ngrok-free.app/webhook/foo`を登録する

  * request pathをそのまま流してくるので登録側にpathまで渡す方式


