# CloudFront

## S3 Origin

* S3のmetadataが http response header に対応する
  * s3 metadataを通じて cacheを制御できたりする
    * cloudfrontでinvalidationしても、browserにindex.htmlがcacheされるので、これを防ぎたい等


## Distribution

* xxxx.cloudfront.net のdomainが割り振られる
  * このdomainの解決の際にcloudfrontのNameServerがuserに近いedgeのIPを返す
  * Userにcloudfront domainを見せたくないのでCNAMEを作るのが一般的
    * CNAME -> xxx.cloudfront.net -> IP とDNS解決が2回必要になる
    * これを避けるためにRoute53にaliasという機能もある
      * Alias(foo.ymgyt.io)がedgeのIPに解決される 
