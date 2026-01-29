# n8n self hosting

* [n8n-hosting repository](https://github.com/n8n-io/n8n-hosting/tree/main)

## Configuration


* `DB_TYPE`: 利用するdb
  * `sqlite`
  * `postgresdb`
* `DB_PING_INTERVAL_SECONDS`
* `DB_POSTGRESDB_POOL_SIZE`

* `QUEUE_HEALTH_CHECK_ACTIVE=true`: `/healthz` endpointを有効化
  * https://docs.n8n.io/hosting/logging-monitoring/monitoring/#enable-metrics-and-healthz-for-self-hosted-n8n

* `N8N_SMTP_SSL`
  * true: SMTPS(最初からTLSなSMTP)を使う
  * false: `STARTTLS`を使う

* `N8N_ENCRYPTION_KEY`
  * Credentialの暗号化に利用する
  * 指定されないと初回に作成して、`~/.n8n`に保存する
