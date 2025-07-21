# Aurora DSQL

## Authentication

* 署名付きIAM認証トークンをパスワードとして利用する

* 認証トークンの生成方法
```sh
cluster_public_endpoint="xxx.dsql.ap-northeast-1.on.aws"

 aws dsql generate-db-connect-admin-auth-token \
  --region ap-northeast-1 \
  --expires-in 3600 \
  --hostname ${cluster_public_endpoint}
```

### psqlの接続

```sh
export PGPASSWORD=$(aws dsql generate-db-connect-admin-auth-token)
export PGSSLMODE = "require"

psql \
  --username admin \
  --dbname postgres \
  --host ${cluster_public_endpoint} 
```

## IAM

* posgreの`admin` roleを利用する場合は以下のpolicyをIAM Identityに付与する
  * `admin` roleはDSQLが自動的に作成する

```json
{
  "Effect": "Allow",
  "Action": "dsql:DbConnectAdmin",
  "Resource": "arn:aws:dsql:us-east-1:123456789012:cluster/my-cluster"
}
```

* custom database 

```json
{
  "Effect": "Allow",
  "Action": "dsql:DbConnect",
  "Resource": "arn:aws:dsql:us-east-1:123456789012:cluster/my-cluster"
}
```


## PostgreSQL Protocol

| PostgreSQL | DSQL               | Memo                      |
|------------|--------------------|---------------------------|
| role       | データベースロール | admin?                    |
| hostname   | cluster endpoint   |                           |
| port       | 5432 固定          |                           |
| dbname     | postgres           | cluster作成時に作成       |
| SSL Mode   | 常に有効           | SSLを使用しない場合は拒否 |
| password   | 認証token          |                           |

## 制約

* `CREATE DATABSE`不可
  * `postgres`のみ
* Transaction Isolation Level は `REPETABLE READ`固定

## Custom roleの作成

1. `admin`で接続して

```sql
AWS IAM GRANT custom-db-role TO 'arn:aws:iam::account-id:role/iam-role-name';
```

## References

* [NewSQLなんも分からん人がゼロからAmazon Aurora DSQLを理解する(前編)](https://qiita.com/tenn25/items/6acf76fce783486989e7)
* [NewSQLなんも分からん人がゼロからAmazon Aurora DSQLを理解する(後編)](https://qiita.com/tenn25/items/0c9a255bbcc6c9f33a40)
