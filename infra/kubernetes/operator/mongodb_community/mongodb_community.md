# MongoDB Community Operator

## Install

* `git clone https://github.com/mongodb/mongodb-kubernetes-operator.git` 
  * versionに留意(`git checkout v0.7.2`のようにtag指定する)

```shell
# mongodbcommunity/v0.7.2配下にmongodb-kubernetes-operatorがいる前提

# CRDの作成
kubectl apply -f mongodbcommunity/v0.7.2/config/crd/bases/mongodbcommunity.mongodb.com_mongodbcommunity.yaml        
# CRDの確認
kubectl get crd/mongodbcommunity.mongodbcommunity.mongodb.com

# Role and role-bindingsの作成
# namespaceがある前提
kubectl apply -k mongodbcommunity/v0.7.2/config/rbac/ --namespace tinypod

# Operatorの作成
# kustomize利用していないので注意
kubectl create -f mongodbcommunity/v0.7.2/config/manager/manager.yaml --namespace tinypod  
# Operatorの確認
kubectl get pods --namespace tinypod
```

## Deploy


