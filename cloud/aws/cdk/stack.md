# Stack

* unit of deployment
* appに複数のstackを渡せる

```typescript
const app = new App();

new MyFirstStack(app, 'stack1');
new MySecondStack(app, 'stack2');
```

## 環境の表現

```typescript
import { App, Stack } from 'aws-cdk-lib';
import { Construct } from 'constructs';

interface EnvProps {
  prod: boolean;
}

// imagine these stacks declare a bunch of related resources
class ControlPlane extends Stack {}
class DataPlane extends Stack {}
class Monitoring extends Stack {}

class MyService extends Construct {

  constructor(scope: Construct, id: string, props?: EnvProps) {
  
    super(scope, id);
  
    // we might use the prod argument to change how the service is configured
    new ControlPlane(this, "cp");
    new DataPlane(this, "data");
    new Monitoring(this, "mon");  }
}

const app = new App();
new MyService(app, "beta");
new MyService(app, "prod", { prod: true });

```
こうすると都合6のstackが作成される

```shell
$ cdk ls
    
betacpDA8372D3
betadataE23DB2BA
betamon632BD457
prodcp187264CE
proddataF7378CE5
prodmon631A1083
```

## AWS AccountとRegionの指定

```typescript
const envEU  = { account: '2383838383', region: 'eu-west-1' };
const envUSA = { account: '8373873873', region: 'us-west-2' };

new MyFirstStack(app, 'first-stack-us', { env: envUSA });
new MyFirstStack(app, 'first-stack-eu', { env: envEU });
```

* StackとEnvironmentの関係は3つに分類できる
  * env指定なし
    * environment-agnostic stackになり一部の機能が制限される
  * `env: { account: process.env.CDK_DEFAULT_ACCOUNT }`の指定
    * synth時にcli command実行時の情報が渡される
  * hard code
    * これが推奨というか安全と思われる

## Stack名の指定

```typescript
// こうするとstackNameを指定できる
new MyStack(this, 'not:a:stack:name', { stackName: 'this-is-stack-name' });
```

## Cross Stack Reference

stack間で値を参照する方法

### exportする側(被参照)

```typescript
import { CfnOutput, Stack, StackProps } from "aws-cdk-lib";

export interface ExportStackProps extends StackProps {}

export class EcrRepositoryStack extends Stack {
  constructor(scope: Construct, id: string, props: ExportStackProps) {
    super(scope, id, props);
    
    new CfnOutput(this, "cfnExportValueA", {
      // 大抵作成したresourceのarnや名前
      value: "exportResourceArn",
      // 参照時の識別子
      exportName: "exportValueA",
    });
  }
}
```

### exportされた値を利用する側(参照)

```typescript
import {Stack, StackProps, Fn } from "aws-cdk-lib";

export interface AppRunnerStackProps extends StackProps {}

export class AppRunnerStack extends Stack {
    constructor(scope: Construct, id: string, props: AppRunnerStackProps) {
        super(scope, id, props);

        const resourceArn = Fn.importValue("exportValueA")
    }
}
```

### app

```typescript
const app = new cdk.App();

const ecrRepoStack = new EcrRepositoryStack(app, "EcrRepoStack", {});
const appRunnerStack = new AppRunnerStack(app, "AppRunnerStack", {});

appRunnerStack.addDependency(ecrRepoStack);
```

* `addDependency()`で依存性を表現する。
