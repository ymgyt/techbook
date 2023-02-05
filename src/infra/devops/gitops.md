# GitOps

InfraとApplicationが宣言的にdescribedされていて、gitでversion管理されている運用手法。  
また、repositoryの状態とdeployされている状態が一致する仕組みを備えている。

## Source codeとInfra codeのrepositoryを分離するべきか

結論: 分離するべき
理由

* application開発者とproduction environmentにpushできる運用者は一致しないから
* App側のCIをtriggerせずにinfraを変更できる
  * replica setの数変えたり
* audit logがきれいになる
* applicationが複数になった場合、どれかひとつのappにinfraコードがあるのは変
* CI pipelineからmanifestの変更をpushしたら無限ループになる

[ArgoCD BestPractice](https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices/) の記載の自分の理解。
