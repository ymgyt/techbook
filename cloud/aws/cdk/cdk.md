# CDK

## Install

```
npm install -g aws-cdk
```

## Bootstrapping

```console
cdk bootstrap aws://ACCOUNT-NUMBER/REGION
```

* lambdaやdocker image等、置いておくためにaccount/region毎に一度だけこの操作が必要

## Init

```console
cdk init app --language typescript
```

## List stacks

```console
cdk ls
```

## Synth

```consle
cdk synth
# stackを指定することもできる
cdk synth stack1
```

* cdk appをCloudFormationに変換する
* `cdk.out` directoryに結果が保持される

## Deploy

```console
cdk deploy
```

## Diff

```console
cdk diff
```

* deploy後にcodeを変更したあと差分をみれる

## Destroy

```console
cdk destroy
```

* CloudFormation Stackを削除する
