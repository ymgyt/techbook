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

## Runtime context

### `cdk.json`と`cdk.context.json`


## Deploy対象のAWS Account

```typescript
new MyDevStack(app, 'dev', { 
  env: { 
    account: process.env.CDK_DEFAULT_ACCOUNT, 
    region: process.env.CDK_DEFAULT_REGION 
}});
```

* 環境変数 `CDK_DEFAULT_{ACCOUNT,REGION}`を利用するとcdk synth時に`--profile`で指定したaccountを対象にできる
* accountをcodeにhard codeするか実行時に解決できるようにしておくかはポリシー次第
