# EKS Fargate

* Managedなcontainer実行基盤
* EKS Clusterにfargate profileを定義できる
* FargateはPodのselectorをもち、これにPodがmatchするとfargate上でpodが起動される
  * cluster管理者はpodごとのresourceをきにしなくてよい(ことになる)
  * selectorにはnamespaceとlabelを指定できる

* Subnet
  * Private subnet(internet gatewayへのrouteをもたない)のみ
  * public ipを割り当てられないから 

* Pod実行role
  * IAM Roleを指定できる
  * fargate上で実行されるkubeletはECRからのimage取得等でAWS APIを呼ぶ必要がある
