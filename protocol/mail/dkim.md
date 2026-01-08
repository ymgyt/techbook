# DKIM

## 検証

1. Header `DKIM-Signature`をみる
  * `d=` で署名domainを取得
  * `s=` 鍵の識別子を取得
2. DNSで公開鍵を取得
3. メールの内容を再計算して、署名検証
4. 結果判定
  一致: DKIM=pass
  不一致: DKIM=fail
