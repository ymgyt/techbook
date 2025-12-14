# STUN

Session Traversal Utilities for NAT

- NAT越しにnode間でUDPでsessionを貼るためのプロトコル(?)
- UDPホールパンチとも？

## Protocol

RFCを読んだわけではないのでイメージ。

- Node-A, Node-B間で通信したい。両者はそれぞれ異なるネットワークにいて,NATがいる
- STUN Serverに対して、Node-A,Node-Bは接続を確立している

1. Node-AがSTUNに通信する
  * NATを経由するので、STUNはNode-Aに割り当てられたpublicIPを知れる
2. Node-Bも同様にSTUNに通信する
3. STUNはNode-A,Bに両者のpublicIPを通知する
4. Node間で、互いのpublicIPにパケットを投げる
5. NATからみるとoutboundのレスポンスに見えるので接続が確立される


## 関連Protocol

- TURN
  * STUNがうまくいかないときに中継server経由でやりとりするためのfallback的なプロトコル

- ICE
  * STUN, TURNの手順を定めている？
