# Ephemeral

* terraformのplan, stateの処理の中で secret valueを永続化させない仕組み。
* produceとconsumeを分けて考えるとわかりやすい
* ephemeral をconsumeできる場所を ephemeral contextという

## Produce

```hcl
ephemeral "aws_secretsmanager_secret_version" "db" {
    secret_id = aws_secretsmanager_secret.db.id
}
```

* child moduleのoutput にも利用できる
  * root module output は不可


## Consume

`_wo` suffix fieldがepheral valueを書き込める。
つまり resource 側が対応している必要がある。

```hcl
resource "aws_db_instance" "main" {
    password_wo         = ephemeral.aws_secretsmanager_secret_version.db.secret_string
    password_wo_version = 1
}
```

* `_wo_version` が肝でこれがかわらない限り、更新処理(rotation)が走らない
* `_wo` write-only argumentは ephemeral or non-ephemeral valueをうけいれる


## Examples

### Secrets Manager

Secretの生成

```hcl
ephemeral "random_password" "db_password" {
  length           = 16
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "db_password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id                = aws_secretsmanager_secret.db_password.id
  secret_string_wo         = ephemeral.random_password.db_password.result
  secret_string_wo_version = 1
}
```

生成されたsecretをephemeral resource で読み直す

```hcl
ephemeral "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret_version.db_password.secret_id
}

resource "aws_db_instance" "example" {
  // ...
  password_wo         = ephemeral.aws_secretsmanager_secret_version.db_password.secret_string
  password_wo_version = aws_secretsmanager_secret_version.db_password.secret_string_wo_version
}
```

### random_password

```hcl

ephemeral "random_password" "db_password" {
  length           = 16
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "example" {
  engine              = "postgres"
  // ...
  password_wo         = ephemeral.random_password.db_password.result
  password_wo_version = 1
}
```

passwordは毎回ランダムに生成されるが、`password_wo_version` がかわらない限り、初回の値が参照されつづける
