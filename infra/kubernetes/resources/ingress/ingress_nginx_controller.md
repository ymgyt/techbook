# ingress-nginx-controller

* controllerだけど、manifestをwatchして、controller Pod自身がroutingをうけもつ?
  * controllerとrouting用のPodが違うわけではない?
* Ingress resourceに対応して
  * Serviceが作成される
    * これはLoadBalancer type?
    * Ingressの設定をencodeしたnginx podが紐づく

## 参考

* [Kubernetes アプリケーションの公開 Part 3: NGINX Ingress Controller](https://aws.amazon.com/jp/blogs/news/exposing-kubernetes-applications-part-3-nginx-ingress-controller/)
