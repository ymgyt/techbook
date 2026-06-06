# adduser

useradd binaryのwrapper

```sh
# create user for foo application
useradd \
	--uid 10001 \
	--gid 10001 \
	--no-create-home \
	--shell /usr/sbin/nologin \
	--comment "foo runtime user" \
  foo
```
