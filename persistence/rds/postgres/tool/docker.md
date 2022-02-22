# Postgres Docker Image

## docker-compose

https://hub.docker.com/_/postgres

```yaml
version: '3.7'
services:
  postgres:
   image: postgres:11.14-bullseye
   container_name: taskmanager_postgres
   environment:
     POSTGRES_USER: taskmanager
     POSTGRES_PASSWORD: secret
     POSTGRES_DB: taskmanager
   ports:
     - 5432:5432
```

`psql --port=5432 --host=localhost --username=taskmanager --password taskmanager` これで接続できる。

