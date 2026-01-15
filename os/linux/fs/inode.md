# inode

* `include/linux/fs.h`


```c
/*
 * Keep mostly read-only and often accessed (especially for
 * the RCU path lookup and 'stat' data) fields at the beginning
 * of the 'struct inode'
 */
struct inode {
  /* ... */
	struct address_space	*i_mapping;
};
```


## page cache

* `include/linux/fs.h`

```c
struct address_space {
	struct inode		*host;
	struct xarray		i_pages;
} 
```

* `inode->address_space`でpage collectionへの参照を保持している
  * このメモリにあるfile metadata(inode)と物理ページの対応関係こそが"page cache"(が今の仮説)
