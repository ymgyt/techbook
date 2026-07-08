# cloud-init

* systemdで実行するscript
* 共通のbase image(AMI) を使いつつ、VM/Instanceをカスタマイズしたいという課題に対応
  * 最低限のimageを使って、cloud-initでSSH,network,... を設定して、ansibleみたいなレイヤー
* VMの設定でもdebian cloud imageを使いつつ、cloud-initでprovisionみたいな使い方ができる
