# DynamoDB

## Capacity Unit

Autoscaleの設定で1秒ごとのRead Capacity Unit(RCU), Write Capacity Unit(WCU)を設定する。  
CUはDynamoDBへのAPIによって消費される。  
実際に消費されるCUはAPIのOperationごとに異なる。

ベースになるのは扱うitemのbyte数。byte数を表示してくれるサイト等があるのでそこで図っておくと目安になる。

### Read

defaultのeventually-consistentの場合、1RCUで8KBまでのitemを扱える。


## 参考

[How to Calculate a DynamoDB Item's Size and Consumed Capacity](https://zaccharles.medium.com/calculating-a-dynamodb-items-size-and-consumed-capacity-d1728942eb7c)
