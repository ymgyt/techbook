# Logging Architecture

https://kubernetes.io/docs/concepts/cluster-administration/logging/#how-nodes-handle-container-logs

概要としては

1. Pod(container)はstdout,stderrにlogを出力する
2. Container runtimeがkubeletの指示にしたがってlogをfileに出力する
3. Daemonsetでdeployしているagentが`/var/log/pods/`配下のlog fileをk8s外のsystemに送信する 
  * 厳密には`/var/log/pods/<namespace>_<pod_name>_<pod_id>/<container_name>/`