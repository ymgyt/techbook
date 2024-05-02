# posix.authorized_keys

```yaml
---
# 各serverのssh authorized_keyに開発者ごとのkeyを設置する。
# root userの存在を前提にしている。
#
- name: Create ssh directory
  become: true
  ansible.builtin.file:
    path: /root/.ssh
    state: directory
    owner: "root"
    group: "root"
    mode: "0700"

- name: Put authorized_keys
  become: true
  ansible.posix.authorized_key:
    user: "root"
    state: "{{ item.ssh.authorized_key.state }}"
    key: "{{ lookup('file', 'files/admin/public_keys/' + item.name) }}"
    path: "/root/.ssh/authorized_keys"
  loop: "{{ admin_users }}"
```

variable

```yaml
admin_users:
  - name: "me"
    ssh:
      authorized_key:
        state: present
  - name: "retiried"
    ssh:
      authorized_key:
        state: "absent"
```

* `state: "absent"`としないと鍵が削除されないので注意
