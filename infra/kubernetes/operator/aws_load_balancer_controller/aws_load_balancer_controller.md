# AWS Load Balancer Controller

* 元はAWS ALB Ingress Controllerだったが改名した

## 動作の概要

1. Controllerはingress resourceをwatch
  * requirementを満たすingressの場合、AWS Resourceを作成する

2. ALBがAWS内にingressのために作成される
  * internet-facing or internalを選べる
  * subnetを指定できる

3. Ingress resource内のService resourceごとにTarget Groupsが作成される

4. Ingress resourceのportに応じて、Listenersが作られる

5. RulesがIngress resourceのpathに従って作られる

| Ingress | AWS          |
| ---     | ---          |
| Ingress | ALB          |
| Service | Target Group |
| Path    | Rule         |


## Traffic

* 2つのtraffic modeがある
  * Instance mode
  * IP mode

### Instance mode

* default
* `alb.ingress.kubernetes.io/target-type` annotationで指定する
* ServiceのNodePortにtrafficを流す
  * Ingressから参照されているServiceは`type: NodePort`を指定しなければならない

## IAM 

* controllerはworker nodeで起動する
* ALB等のAWS resourceを制御するためにIAM permissionが必要
