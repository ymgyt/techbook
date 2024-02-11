# Semanti Convention

* Service
  * `service.name`: applicationの名前
  * `service.version`: applicationのversion
  * `service.namespace`: service.nameの名前空間(nameとあわせて一意になる的な?)
  * `service.instance.id`: Pod IDとかいれる

* Enduser: authenticated/authorizedされた操作の主体
  * `enduser.id`: usernameやclient_id
  * `enduser.role`: admin等のrole
  * `enduser.scope`: OAuthのscope(`write:foo`)
