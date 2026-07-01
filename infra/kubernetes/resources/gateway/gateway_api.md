# Gateway API

* Ingress + annocations で全部設定を再整理したもの
* role based
  * application devがALBの共通設定に影響する設定を変更するみたいなことがなくなる

## Resource

* GatewayClass
  * infra providerが担当
* Gateway
  * cluster管理者が担当
  * traffic handling infrastructure instace
  * load balancerとしてcontrollerが実体化させる
* HTTPRoute
  * application devが担当
  * http traffic rule
* GRPCRoute
  * application devが担当
  * grpc traffic rule

## References

* [Kubernetes Gateway API の成り立ちを調べてみた](https://developersblog.dmm.com/entry/2025/12/12/113000)
* [AWS Load Balancer Controller が Kubernetes Gateway API サポートの一般提供を開始](https://aws.amazon.com/jp/blogs/news/aws-load-balancer-controller-adds-general-availability-support-for-kubernetes-gateway-api/)
