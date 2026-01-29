# Queue Mode

複数インスタンス構成。むしろこれが本番。

## Components

* Main(namanger)
  * UI/API/Trigger
  * workflowの実行要求をenqueueする
* Redis
  * job queue
* Worker instance
* DB
