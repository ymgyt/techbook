# tmpfs

メモリをfilesystem interfaceで使えるようにしたもの

## 流れ

1. `fd = open("/mnt/tmpfs/a.txt", O_RDWR | O_CREAT, 0644)` でtmpfsにfileが作られる
  * VFSがメモリ上に `a.txt`に対応するinode instanceを保持
  * inode->i_mapping(address_space)は空で対応するpage tableはない

2. `write(fd, "a", 1)`のように書き込みが走る
  * inode->i_mappingでpage collectionを検索
  * まだないので、pageをallocateしてinodeの`i_mapping->i_pages`に登録
  * pageに書く

3. `read(fd, buf, 1)`で読まれる
  * inode->i_mapping->i_pagesから読む
