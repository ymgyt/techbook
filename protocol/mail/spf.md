# SPF

送信元が称するdomainからDNSでTXT -> IPアドレスを探して、実際のTCP 送信元IPと一致するか判定する仕組み

## 検証手順

0. 送信元IPを見る
1. MAIL FROM: `foo@ymgyt.io` からSPF Domain `ymgyt.io`を決める
2. DNS で `ymgyt.io`のSPF TXT Recordを引く
  ```text
  v=spf1 include:_spf.google.com include:amazonses.com -all
  ```
3. SPF Recordを評価する
  * 例えば include先のIPを取得して、送信元IPと一致するか判定する
4. 結果を判定する
  * SPF=pass
  * SPF=fail
  
