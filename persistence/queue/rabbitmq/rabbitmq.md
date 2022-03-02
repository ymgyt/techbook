# RabbitMQ

## Connection

* https://www.rabbitmq.com/uri-spec.html
* `amqp://user:pass@host:10000/%2f`
  * `%2f`はuri encodeで`/`を表す(つまりdefault vhost)

```text
amqp_URI       = "amqp://" amqp_authority [ "/" vhost ] [ "?" query ]

amqp_authority = [ amqp_userinfo "@" ] host [ ":" port ]

amqp_userinfo  = username [ ":" password ]

username       = *( unreserved / pct-encoded / sub-delims )

password       = *( unreserved / pct-encoded / sub-delims )

vhost          = segment
```

## AMQP

* https://www.rabbitmq.com/resources/specs/amqp0-9-1.pdf

## Port

* `5672`  : http
* `15672` : web console 
* https://www.rabbitmq.com/troubleshooting-networking.html

## Environment Variable

* https://www.rabbitmq.com/configure.html#supported-environment-variables
