# ExternalDNS

* 公開されたServiceとIngressをDNSとproviderと連携させる
  * kubernetesのresourceを通じて外部のDNS recordを変更できるようになる

## 解決したい課題

serviceで`type=LoadBalancer`を指定することで、serviceを外部に公開することはできる。ただし

```sh
$ kubectl get svc
NAME      CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
nginx     10.3.249.226   35.187.104.85   80:32281/TCP   1m
```

環境によるが一般的には、adhocなIP/DNS nameが割り当てられるので、そのままではproductとして公開に適さない。  
そこで、振り出されたIPを別のDNS Providerに登録する。  
これはIPが変わるたびに行う必要がある。  
external-dnsはDNS recordとexternal entry pointを同期させることでこの問題に対処する


## DNS Nameとして利用されるkubernetes object

1. Ingress
  * ingress objectのhostname
  * `external-dns.alpha.kubernetes.io/hostname` annotations

2. Service
  * `external-dns.alpha.kubernetes.io/hostname` annotations

3. compability mode
4. `--fqdn-template`


参考 [How do I specify a DNS name for my Kubernetes objects?](https://kubernetes-sigs.github.io/external-dns/v0.14.2/faq/#how-do-i-specify-a-dns-name-for-my-kubernetes-objects)


## Policy

* policyを`upsert-only`にするとDNS Recordは削除されなくなる
* policyを`sync`にすると削除までされる
* `txtOwnerId`とは...

## domain filter

* `--domain-filter=.example.org`を指定すると、`.example.org`で終わるzoneのみを対象にする
