# Ansible

## Usage

### Adhoc commandの実行

```shell
ansible <group> -m command -a uptime -i inventories/inventory.ini

# callback plugingの指定
ANSIBLE_STDOUT_CALLBACK=default ansible <group> -i inventory.ini -m command -a 'docker image ls'
```

* command moduleで`-a`で渡すcommandを実行できる
  * `<group>`はinventory内のgroup
* `ANSIBLE_STDOUT_CALLBACK`で出力方法を指定できる。
  * [pluginのlist](https://docs.ansible.com/ansible/2.6/plugins/callback.html#plugin-list)

### Playbookの実行

```shell
ansible-playbook <host_group> -i inventory.ini <play-book>.yaml

# DryRun
ansible-playbook --check <host_group> -i inventory.ini <play-book>.yaml

# 適用対象のhostを制限
ansible-playbook -i inventory.ini <play-book>.yaml --limit target-host-a
```

* `--check`
  * check modeで実行する。各moduleはcheck mode時の動作を実装しており挙動が変わる


## Subcommands

### `ansible-inventory`

```shell
ansible-inventory --graph -i inventories/inventori.ini
```

* inventoryの内容(group)を表示できる

### `ansible-doc`

```shell
# service moduleのdocをみる
ansible-doc service
```

## Variables

variables.mdを参照。
