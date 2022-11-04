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

## `archive`

remoteのdirectoryを一つのfileにする

```yaml
- name: Archive remote k8s work directory
  community.general.archive:
    path: /path/to/dir
    dest: "/tmp/dir.tar.gz"
    format: gz
```

## `unarchive`

remoteのarchiveをunarchiveする

```yaml
- name: Unarchive k8s workdir
  ansible.builtin.unarchive:
    src: "/tmp/target.tar.gz"
    dest: "/app"
    remote_src: true
```

* `remote_src`はunarchive対象fileが既にremoteにある場合、true
* 実行すると`/app/`配下にtarget.tar.gzが展開される。

## `fetch`

remoteからlocalにfileをもってきたい場合はこれ

```yaml
- name: Fetch remote target archive to local
  ansible.builtin.fetch:
    src: "/tmp/target.tar.gz"
    dest: "{{ role_path }}/files/archives/"
```

* remoteの`src` fileをlocalの`dest`にもってくる


