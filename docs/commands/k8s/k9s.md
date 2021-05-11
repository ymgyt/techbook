# k9s

## Install

```shell
# mac
brew install k9s
brew upgrade k9s
```

## Usage

```shell
# readonlyつけておくと安心かも
k9s --request-timeout=30s --namespace=knight --readonly
```
