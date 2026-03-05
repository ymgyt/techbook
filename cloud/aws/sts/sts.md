# STS

## AssumeRoleWithWebIdentity

* 外部のID TokenからIAM Role Credentialを取得するAPI
* STSはID Tokenを検証するのでなんらかの事前の信頼関係構築は必要
* AWS Principal(IAM User,Role)を持たずにRoleをassumeできる
