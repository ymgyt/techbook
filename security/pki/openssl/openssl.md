# openssl

## Private keyの生成

```shell
openssl genrsa -out ymgyt.key 2048
```

## Certificate Sign Requestの生成

```shell
openssl req -new -key ymgyt.key -subj "/CN=ymgyt" -out ymgyt.csr
```

## Certificateの表示

```sh
file foo.crt
foo.crt: PEM certificate

openssl x509  -text -noout -in ./foo.crt
```


