# Task

## EC2にssh接続する

* key pairの作成
```shell
# passphraseは入力しない
ssh-keygen -m PEM
````
* EC2 console -> KeyPairからimportする
* EC2作成時のKeyName(cdk)でimportしたkeypairを指定する
* AMIがUbuntuの場合
  * `ssh -i ~/.ssh/generated_key ubuntu@ec2-host-name` で接続する 
