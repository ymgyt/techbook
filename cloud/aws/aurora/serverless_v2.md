# Aurora Serverless V2

## Aurora Capacity Unit(ACU)

* 1ACU = 2GiBメモリ
* 負荷に応じて増減するのでmin,maxを決める

## Engine

* engine versionはどのpostgresqlのversionを使いたいか

```sh
# 利用可能なengine version 
 aws rds describe-db-engine-versions --engine aurora-postgresql | from json | get
 DBEngineVersions | select EngineVersion Engine
```
