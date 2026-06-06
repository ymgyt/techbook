# useradd

```sh
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
```

* `-s|--shell`: shell
* `-g|--gid`: primary groupの名前or gid
* `-m|--create-home`: create user home directory
* `-k|--skel`: home directory配下に作られるtemplate
