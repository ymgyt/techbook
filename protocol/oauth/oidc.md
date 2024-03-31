# OpenID Connect

IP Provider(Github等)のaccountによって、third partyにloginできる

OIDC = OAuth + ID token + UserInfo endpoint

Userがgrant codeもってくるので、それをID Provider(認可Server)に渡すと、ID tokenを返してくれる。これだけ。  
OAuthの場合は、acces tokenがprofile api叩いて、userを認証するが、その必要がない。

## OAuthとの対応

| OAuth          | OIDC          |
| ---            | ---           |
| Resource Owner | Enduser       | 
| Client         | Relying party | 
| 認可Server     | ID Provider   |

その他、grant typeはflowと呼ばれる


## Scope

OAuthではscopeの形式等については仕様で定まっていなかった。  
OIDCでは以下が決められている。

| Value   | What you get                |
| ---     | ---                         |
| openid  | OpenID Connectのrequest表す |
| profile | profile情報                 |
| email   | email, email_verified       |
| address | address                     |
| phone   | phone_number, phone_number_verified |


## ID Token

ID Providerがaccess tokenと同じresponseで返す。  
formatは署名付きJWT


## UserInfo endpoint

OAuthではResourceは仕様で決まっていないが、OIDCはUser Info resourceを仕様で定めている。  
accessするには、access tokenが必要。
