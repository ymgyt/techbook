# Develop Environment

1. Debian imageの取得
  * https://www.debian.org/distrib/netinst

2. VMのport forwardingを設定
  * VM設定 > Network
    * Adaptor1 = NAT
    * Port forwarding
      * rule: ssh
      * hostport: 2222(or anything)
      * guestport: 22
  * Guestで `systemctl status ssh`を確認
  * Hostから `ssh -p 2222 <me>@localhost`
