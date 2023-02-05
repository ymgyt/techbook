# Command

任意のコマンドの実行

## `shell`

```yaml
- name: "Shell"
  ansible.builtin.shell:
    # yamllint disable rule:line-length
    cmd: "yum install -y /local/*.rpm"
  register: yum_install
  # yum install return 1 when package is already installed.
  failed_when: yum_install.rc >= 2
```

* shellの機能を利用する際は`command`ではなく`shell`を利用する
* return codeが0以外でも成功扱いにしたい場合はregisterして判定する

```yaml
  failed_when: yum_install.rc >= 2 or 'does not update installed package' not in yum_install.stdout
```

* `or`使える
* 特定のerrorを許容したい場合は`'error message' not in register_var.stdout`と書ける

## `command`

```yaml
- name: Download yum packages
  ansible.builtin.command:
    chdir: /path/to/workdir
    argv:
      - "yumdownloader"
      - "--assumeyes"
      - "--destdir={{ item.dest }}"
      - "--resolve"
      - "{{ item.name }}"
  loop:
    - name: yum-utils
      dest: yum
    - name: bash-completion
      dest: yum
```

* `chdir`でcurrent workdirを指定できる
