# Vault Policy

Plicyはpathとoperationに対するgrant or forbidを宣言する方法。


```
# Grant 'create', 'read' and 'update' permission to paths prefixed by 'secret/data/test/'
path "secret/data/test/*" {
  capabilities = [ "create", "read", "update" ]
}

# Manage namespaces
path "sys/namespaces/*" {
   capabilities = [ "create", "read", "update", "delete", "list" ]
}
```

* 適用範囲はpathのprefix
  * most specific defined plicyが利用される
* Policyはnamespaceに紐づく
* `hcp-root` policyはadmin tokenと紐づいているのでeditしない
