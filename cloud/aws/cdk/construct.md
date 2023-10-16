# Construct

* represents "cloud component"
  * 再利用の単位
  * CloudFormationをどの程度抽象化しているかでL1とL2に分かれる
  * CDK v2から、`constructs` moduleに分離された(v1ではcore)

* Layerの概念をもつ
  * L1.CfnResource
    * Cloudformationに対応する
  * L2. intent-based API
    * default値を設定してくれている
    * `bucket.addLifeCycleRule()`とかでbucketの設定できるイメージ


## Constructの定義

* 自分でも定義できる
* instanceのpropertyを追加したい場合は、classのfieldを定義する

```typescript
export class NotifyingBucket extends Construct {
  public readonly topic: sns.Topic;

  constructor(scope: Construct, id: string, props: NotifyingBucketProps) {
    super(scope, id);
    const bucket = new s3.Bucket(this, 'bucket');
    this.topic = new sns.Topic(this, 'topic');
    bucket.addObjectCreatedNotification(new s3notify.SnsDestination(this.topic), { prefix: props.prefix });
  }
}

const queue = new sqs.Queue(this, 'NewImagesQueue');
const images = new NotifyingBucket(this, '/images');
images.topic.addSubscription(new sns_sub.SqsSubscription(queue));
```

## Import

* cdk以外で作成されたResourceをcdk内に取り込む
* Stack作成時のpropsに`Environemnt`(Aws account, region)を渡しておく必要がある

```typescript
// Construct a resource (bucket) just by its name (must be same account)
s3.Bucket.fromBucketName(this, 'MyBucket', 'my-bucket-name');

// Construct a resource (bucket) by its full ARN (can be cross account)
s3.Bucket.fromBucketArn(this, 'MyBucket', 'arn:aws:s3:::my-bucket-name');

// Construct a resource by giving attribute(s) (complex resources)
ec2.Vpc.fromVpcAttributes(this, 'MyVpc', {
  vpcId: 'vpc-1234567890abcde',
});

// Provide aws account for import
const app = new cdk.App();
new MyStack(app, 'MyStack', { env: 
        { account: awsAccount, region: "ap-northeast-1" } 
})
```

## Removal Policy

* Resource削除時の挙動の制御
  * RETAIN
    * stackが削除されても残りつづけ手動の削除が必要
    
```typescript
import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';
  
export class CdkTestStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
  
    const bucket = new s3.Bucket(this, 'Bucket', {
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      autoDeleteObjects: true
    });
  }
}
```

## Tag

```typescript
import { App, Stack, Tags } from 'aws-cdk-lib';

const app = new App();
const theBestStack = new Stack(app, 'MarketingSystem');

// Add a tag to all constructs in the stack
Tags.of(theBestStack).add('StackType', 'TheBest');

// Remove the tag from all resources except subnet resources
Tags.of(theBestStack).remove('StackType', {
  excludeResourceTypes: ['AWS::EC2::Subnet']
});
```

## L1を利用

L2のmethodやpropertyでは設定できない項目があったりする。  
その場合、L2からL1に変換を行い、直接CloudFormationの項目を設定できる

```typescript
// Get the CloudFormation resource
const cfnBucket = bucket.node.defaultChild as s3.CfnBucket;

// Change its properties
cfnBucket.analyticsConfiguration = [
  { 
    id: 'Config',
    // ...        
  } 
];
```

* `construct.node.defaultChild as CfnXXX`のように行える
* `s3.Bucket.fromCfnBucket()`のようにL1 -> L2の流れもある
* [escape hatch](https://docs.aws.amazon.com/ja_jp/cdk/v2/guide/cfn_layer.html)
