# openapi cli

## Install

```shell
npm install -g @redocly/openapi-cli@latest
```

## Config file

project directoryのtop levelに`.redocly.yaml`を置いておくと`openapi`が読んでくれる。

```yaml
apiDefinitions:
  oas: ./doc/oas/openapi.yaml

lint:
  extends:
    - recommended
  rules:
    boolean-parameter-prefixes:
      severity: error
      prefixes: [ 'should', 'is', 'has','can' ]
  doNotResolveExamples: true
```
