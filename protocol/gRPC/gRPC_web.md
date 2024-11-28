# gRPC-Web

* httpのprotocolでgRPCのbinaryをPOST

## curl

```sh
printf '\x00\x00\x00\x00\x05\n\x03aaa' \
     | curl -v 'http://[::1]:50051/helloworld.Greeter/SayHello' \
      -X POST \
      -H 'content-type: application/grpc-web+proto' \
      --data-binary '@-' \
      --output -
```

https://zenn.dev/daijinload/articles/14a77cd4ae3393
