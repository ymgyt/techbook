# Role

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: app
  name: developer
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get, "create", "list"]
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["get"] 
```

* `""`はcore api groupを表す

```yaml
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get"]
  resourceNames: ["myapp"]
  
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list"]
  resourceNames: ["mydb"]
```

* `resourceNames`で対象を絞れる

# RoleBinding

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: mybinding
subjects:
  - kind: User
    name: ymgyt
    apiGroup: rbac.authorization.k8s.io
  - kind: Group
    name: "developers"
    apiGroup: rbac.authorization.k8s.io
  - kind: ServiceAccount
    name: app
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: developer
```

# ClusterRole

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-admin
rules:
  - apiGroups: [""]
    resources: ["nodes"]  
    verbs: ["get", "create", "list", "delete", "update"]  
```

* cluster wideなresourceとしては
  *`nodes`
  * `namespaces`
