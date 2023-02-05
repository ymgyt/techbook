# Linux

## `selinux`

selinuxの状態を宣言する

```yaml
- name: Configure selinux to permissive
  ansible.posix.selinux:
    policy: targeted
    state: permissive
```
