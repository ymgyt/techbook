# File management

## `file`

### Create directory

```yaml
- name: Create ssh directory
  ansible.builtin.file:
    path: /root/.ssh
    state: directory
    owner: "root"
    group: "root"
    mode: "0700"
```

## `copy`

### Put local file to remote

```yaml
- name: Add docker-ce yum repository
  ansible.builtin.copy:
    src: files/xxx
    dest: "/etc/yyy/xxx
    mode: '0644'
```

