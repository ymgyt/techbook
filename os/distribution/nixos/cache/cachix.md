# Cachix

* `nix profile install --accept-flake-config nixpkgs#cachix`
  * accept flagの意味をわかっていない

## Usage

1. cachix.orgにloginしてbinary cacheを作成する(以下では`syndicationd`をcache nameとする)
  * Write/Readのaccess権限を設定する
    * writeはapi token、readはpublic等

2. `cachix use syndicationd`
  * `~/.config/nix/nix.conf`に設定が追加される

```text
substituters = https://cache.nixos.org https://cache.nixos.org/ https://syndicationd.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= syndicationd.cachix.org-1:qeH9C3xDqR831xEuDcfhGEUslMMjGroPPMOwiZfyiJQ=
```

のようになった


## Authentication

cachix.orgでauth tokenをgenerateしたのち

```sh
cachix authtoken <token>
# もしくは
export CACHIX_AUTH_TOKEN = <token>
```

## CI

### Github actions
1. cachix.orgでtokenをgenerateする
2. Github secretsで`CACHIX_AUTH_TOKEN`にsetする

```yaml
name: CI
on:
  pull_request:
  push:
jobs:
  tests:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: cachix/install-nix-action@v22
      with:
        gihtub_acces_token: ${{ secrets.GITHUB_TOKN }}
    - uses: cachix/cachix-action@v14
      with:
        # cachix binary cache name
        name: syndicationd
        authToken: '${{ secrets.CACHIX_AUTH_TOKEN }}'
    - run: nix build
```

1. checkout
2. install nix
3. install cachix
4. Run nix
