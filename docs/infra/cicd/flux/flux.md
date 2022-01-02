# Flux

## Install

```shell
brew install fluxcd/tap/flux

# repo 権限をもったtokenを作成しておく
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>

flux check --pre
```

## Usage

```console
# 事前確認
flux check --pre

# uninstall
flux uninstall --namespace=flux-system
```

## References

* [Monorepo Example](https://github.com/fluxcd/flux2-kustomize-helm-example)
