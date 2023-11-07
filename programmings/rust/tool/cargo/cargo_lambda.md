# cargo-lambda

* [Getting started](https://www.cargo-lambda.info/guide/getting-started.html)

## Install

use nix package `cargo-lambda`


## Usage

```sh
# Create project dir
cargo lambda new foo

# Run local lambda emulator
cargo lambda watch

# Invoke lambda
cargo lambda invoke --data-ascii '{"key": "value"}'

# Build
cargo lambda build --release
```

* `cargo lambda invoke`
  * 事前にwatchが別terminalで実行されている前提
  * `--data-ascii`に渡すのはpayloadのjson. contextは渡さなくてよい

* `cargo lambda build`
  * `target/lambda/<crate_name>`にbuildされる
  * このpathをcdk等のlambdaのassetとして渡せる



## CDK

cdkでcargo lambdaで作成したlambdaをdeploy

```typescript
import { Code, Function, Runtime } from "aws-cdk-lib/aws-lambda";
import { Construct } from "constructs";
import * as iam from "aws-cdk-lib/aws-iam";
import * as path from "path";

export function lambda(scope: Construct, dynamodbTableArn: string): Function {
  const role = new iam.Role(scope, "MyLambdaRole", {
    assumedBy: new iam.ServicePrincipal("lambda.amazonaws.com"),
    description: "Lambda role",
    roleName: "MyLambda",
    inlinePolicies: {
      dynamodb: new iam.PolicyDocument({
        statements: [
          new iam.PolicyStatement({
            actions: ["dynamodb:*"],
            resources: [dynamodbTableArn],
            effect: iam.Effect.ALLOW,
            sid: "allowDynamodbOperation",
          }),
        ],
      }),
    },
  });

  const f = new Function(scope, "MyLambda", {
    functionName: "MyLambda",
    code: Code.fromAsset(
      path.join(
        __dirname,
        "../path/to/cargo_lambda_project/target/lambda/crate_name"
      )
    ),
    runtime: Runtime.PROVIDED_AL2,
    handler: "not_used_in_custom_runtime",
    role,
  });

  return f;
}
```

* `code`: cargo lambdaでbuildしたtargetへのpath
* `runtime`: `provided.al2`を使えばよいらしい
* `handler`: custom runtimeでは利用されないので、なんでもよい
