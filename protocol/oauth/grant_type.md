# Grant type

Clientの認可serverへの事前登録は前提となっている。

以下の説明の前提。  
* 認可endpoint: `https://auth.example.com/authorize`
* Token endpoint: `https://auth.example.com/token`
* Redirect endpoint(URI): `https://client.example.com/callback`

## Client 登録

認可serverのtoken endpointにrequestする際の認証(Authorization header)として以下の情報が必要。

* Client ID
* Client Secret

登録方法は仕様化されていないので、認可server及びResource serverを管理している組織次第。