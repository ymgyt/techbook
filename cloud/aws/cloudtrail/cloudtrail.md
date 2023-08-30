# CloudTrail

## Events

3種類に分類される

* Management events
* Data events
* Insights events

すべてのAPI/Serviceが記録されるわけではない。  
https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-aws-service-specific-topics.html

### Management events

defaultで有効。


### Data events

Resourceの操作に関わるevent。


## Eventの格納方法

CloudTrailがどのようにeventの集合をuserに提供するか。

* Event History
  * management events専用
  * 90 days
  * free(no charge)

* CloudTrail Lake

* Trails
  * これはs3への書き出しのこと?

