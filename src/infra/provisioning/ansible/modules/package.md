# Package management

## apt

```yaml
- name:
  ansible.builtin.apt:
    name: containerd
    state: present
    update_cache: true
    cache_valid_time: 86400
    install_recommends: true
    clean: false
```

* `cache_valid_time`が長いと`apt-get update`相当が実行されないので、packageが見つからないと等あれば0にしてみるとよい
