# Ansible

## Usage

### Adhoc commandの実行

```shell
ansible <group> -m command -a uptime -i inventories/inventory.ini
```

* command moduleで`-a`で渡すcommandを実行できる
  * `<group>`はinventory内のgroup

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
