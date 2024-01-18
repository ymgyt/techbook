# Route53

## Subdomainの作成

* 前提
  * hosted zone `ymgyt.io`が既に作成されている
  * subdomainとして`foo.ymgyt.io`を作りたい

1. Hosted zone `foo.ymgyt.io`を作成する
  * Hosted zoneとしては`ymgyt.io`と`foo.ymgyt.io`は独立している
  * Hosted zoneを作成するとRoute53がname serverを複数作成してくれる
    * Console > Hosted zone Details > Name servers

以下の値が`foo.ymgyt.io`のname serversとして作成されたものとする

```text
ns-1508.awsdns-60.org
ns-1976.awsdns-55.co.uk
ns-552.awsdns-05.net
ns-469.awsdns-58.com
```

2. Hosted zone `ymgyt.io`にNS Recordを作成する
  * 親のdomainにまずqueryが来るので、委譲することを表現する必要がある
  * Create Recordする
    * Record Name: `foo.ymgyt.io`
    * Record Type: `NS`
    * Value: `foo.ymgyt.io`のname servers
      * 上記、`ns-1508...`の4行を貼り付ける
    * TTL: 任意
    * Routing policy: `Simple routing`

3. Hosted zone `foo.ymgyt.io`に管理したいRecordを作成する
  * TXT Recordを作成した場合
    * `dig -t txt test.foo.ymgyt.io`で検証できる
