# Role

* UserとRoleは同じ
  * User = Login権限をもったRole
  * Instance全体で一意

* database ojects(tables, functions)を所有する
　* 他のroleにprivilegesをGRANTできる

```sql
CREATE ROLE name;

DROP ROLE name;

SELECT rolname FROM pg_roles;
SELECT rolname FROM pg_roles WHERE rolcanlogin;
```

* roleの作成
```sql

CREATE ROLE name LOGIN;
--- 同じ意味
CREATE USER name;
```

## References

 
* [ユーザとロール管理のAWS記事](https://aws.amazon.com/jp/blogs/news/managing-postgresql-users-and-roles/)
* [初心者向けハンズオン](https://eng-entrance.com/postgresql-role)
