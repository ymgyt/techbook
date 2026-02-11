# SES

Regionの単位でSandbox(後述)やIdentities等の状態を保持している


## Sandbox

SESを有効化したRegionの初期状態

* From/Toが検証済である必要がある
  * SES Identitiesがある=検証?
* 送信上限あり

### 送信 Quotas

* 24時間以内に送れるメール: 200通まで
* 1秒間に送れる数: 1通
  * CCに4人いれてメールおくるとそのメールは送れるが、5秒間は送れなくなる

* メールは受信者ベースでカウントされる
  * CC: に2人指定したら3通扱い

> Note
  Sending quotas are based on recipients rather than on messages.
  For example, an email that has 10 recipients counts as 10 against your quota. 

> if your send rate quota is one message per second, and you send a message to five recipients at once, Amazon SES lets you do that.
  For the next five seconds, though, Amazon will return errors for all send attempts. Once five seconds have passed, 



## References

* [What Happens When Your Reach Your Sending Limits?](https://aws.amazon.com/blogs/messaging-and-targeting/what-happens-when-you-reach-your-sending-limits/)  
