# Service Control Policy (SCP)

* 実態はIAM Policy
  * ただし権限の付与はせず、Allowならさらに次のpolicyを評価、Denyならdenyと評価される
* Root, OU, Accountにアタッチする
  * アタッチの効果は、IAMのentityおよびroot userに及ぶ
  * __Management accountはSCPの影響を受けない__
* default ではすべてのRoot, OU, Accountに`FullAWSAccess`がアタッチされている


```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
```
