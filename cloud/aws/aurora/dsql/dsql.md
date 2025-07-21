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
* auth tokenを生成したIAM Entityが認可の対象になる
* IAM Roleとpostgres上のroleのmapping
  `AWS IAM GRANT pg_your_role TO 'arn:aws:iam::<account-id>:role/<iam-role-for-app>'`
  * adminの場合は不要
  * pg roleでINSERTやSELECTができるからposgreのpliviledgesで設定する

```json
{
  "Effect": "Allow",
  "Action": "dsql:DbConnectAdmin",
  "Resource": "arn:aws:dsql:us-east-1:123456789012:cluster/my-cluster"
}
```

* custom role(admin以外)

```json
{
  "Effect": "Allow",
  "Action": "dsql:DbConnect",
  "Resource": "arn:aws:dsql:us-east-1:123456789012:cluster/my-cluster"
}
```

## Posgres roleの作成

```sql
CREATE ROLE app LOGIN;

AWS IAM GRANT app TO 'arn:aws:iam::<account-id>:role/<iam-role-for-app>';

GRANT USAGE, CREATE ON SCHEMA app_schema TO app;
GRANT SELECT, INSERT, UPDATE, DELETE
    ON ALL TABLES
    IN SCHEMA app_schema
    TO app;
```

renoke

```sql
AWS IAM REVOKE app FROM 'arn:aws:iam::<account-id>:role/<iam-role-for-app>';
```

## PostgreSQL Protocol

| PostgreSQL | DSQL               | Memo                      |
|------------|--------------------|---------------------------|
| role       | データベースロール | `admin` roleが作成される  |
| hostname   | cluster endpoint   |                           |
| port       | 5432 固定          |                           |
| dbname     | postgres           | cluster作成時に作成       |
| SSL Mode   | 常に有効           | SSLを使用しない場合は拒否 |
| password   | 認証token          |                           |

## 制約

* `CREATE DATABSE`不可で複数databaseは利用できない
  * `postgres`のみ
* Transaction
  * Isolation Level は `REPETABLE READ`固定
  * DDLとDMLの混在不可
  * DDLは一つのみ
* Connection
  * 1時間でタイムアウト
* Constraint
  * Foreign keyは不可
  * Unique 制約も不可
* タイムゾーンはUTC固定
* admin role以外で、`CREATE SCHEMA`不可
 * adminのみがpublic schemaにアクセス可

## Backup

TODO

## Cost

* DPU
  * 100万ユニット/$100
  * CWから確認できる
* Storage
  * 1GB/$0.4
  * Multi regionの場合、regionごとにかかる


## References

* [NewSQLなんも分からん人がゼロからAmazon Aurora DSQLを理解する(前編)](https://qiita.com/tenn25/items/6acf76fce783486989e7)
* [NewSQLなんも分からん人がゼロからAmazon Aurora DSQLを理解する(後編)](https://qiita.com/tenn25/items/0c9a255bbcc6c9f33a40)
