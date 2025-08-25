# NATS

## Concepts

* Subject
  * message送信先の識別子
  * `foo.bar.baz`のように階層表現できる

* NATS Server
  * message broker

* Publisher
  * Subjectを指定してNATS serverにmessageを送る

* Subscriber

* NATS
  * Service discovery機能を担う


## Handson

```sh
 docker run --rm -p 4222:4222 --name my-nats nats:2.11.1-alpine -DV
```
