# Cross Region

* Region-AのBus -> Rule -> Region-B bus のようにしてregionをまたいでeventを連携できる
  * 裏を返すと別Regionのtargetを呼び出せない
  * Cross regionでtargetにできるのはeventbusのみ

## Caller side

* `IAM principalは常にruleに紐づいたIAM role`

以下のIAM Policyが必要

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "events:PutEvents"
            ],
            "Resource": [
                "arn:aws:events:us-east-1:123456789012:event-bus/*"
            ]
        }
    ]
}
```

assume policy
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

rule 送信先のbusのARNを指定すればよさそう

```yaml
Resources:
  EventRuleRegion1: 
    Type: AWS::Events::Rule
    Properties: 
      Description: "Routes to us-east-1 event bus"
      EventBusName: "MyBusName"
      State: "ENABLED"
      EventPattern: 
        source:
          - 'MyTestApp'
        detail:
          - 'MyTestAppDetail'
      Targets: 
        - Arn: "arn:aws:events:us-east-1:123456789012:event-bus/CrossRegionDestinationBus"
          Id: " CrossRegionDestinationBus"
          RoleArn: !GetAtt EventBridgeIAMrole.Arn
```


## References

* [AWS Blog Introducing cross-Region event routing with Amazon EventBridge](https://aws.amazon.com/blogs//compute/introducing-cross-region-event-routing-with-amazon-eventbridge/)
