# Vault token

## Token types

以下の種類がある
* service token  (`hvs.`)
* batch token    (`hvb.`)
* recovery token (`hvr.`)

[公式の比較表](https://fraim.slack.com/archives/C04KZNU0FT9/p1685175103114679)  



### Service token

いわゆるtoken

### Batch token

metada等の必要な情報がすべてencodeされているtoken。  
vault側で永続化されないらしい。  
具体的なユースケースわかってない。


## Lease

root token以外には`default_lease_ttl`と`max_lease_ttl`という二つのTTLがある。

* `default_lease_ttl`
  * tokenをcreate, renewした際のTTL
* `max_lease_ttl`
  * renewする際に、expire_time > issue_time + max_lease_ttlとなる場合にエラーとなる