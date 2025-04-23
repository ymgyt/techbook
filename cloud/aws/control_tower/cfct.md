# Customizations for Control Tower (CfCT)

* AWSが提供するCloudFormation Templateがあり、それをdeployすると、pipeline一式が作られる
* Cf Templateが作るresource
  * CodePipeline
  * CodeBuild
  * Step Functions
  * S3(source code)
  * EventBridge + SQS + Lambda
    * Control tower のevent駆動でlambdaが動く


