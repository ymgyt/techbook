# Mongodb

## ReplicaSet

* clientはreplica setが返すhost名を解決できないといけない
  * https://github.com/mongodb/specifications/blob/master/source/server-discovery-and-monitoring/server-discovery-and-monitoring.rst#clients-use-the-hostnames-listed-in-the-replica-set-config-not-the-seed-list
  * 主にdocker-composeで建てたmongoに接続しに行く際に問題になる
