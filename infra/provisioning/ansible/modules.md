# Modules

## Software dependencies

### `pakage`

### `service`

## File managements

### `file`

#### Create directory

```yaml
- name: Create ssh directory
  ansible.builtin.file:
    path: /root/.ssh
    state: directory
    owner: "root"
    group: "root"
    mode: "0700"
```

### `copy`

#### Put local file to remote

```yaml
- name: Add docker-ce yum repository
  ansible.builtin.copy:
    src: files/xxx
    dest: "/etc/yyy/xxx
    mode: '0644'
```

### `template`

## Test

### `uri`

```yaml
- name: "Test it! https://localhost:8443/index.html"
  delegate_to: localhost
  become: false
  uri:
    url: 'https://localhost:8443/index.html'
    validate_certs: false
    return_content: true
  register: this
  failed_when: "'Running on ' not in this.content"
```

## Debug

### `debug`

```yaml
- name: Debug
  debug:
    # variableの内容を確認できる
    var: ["key_1"] 
```
