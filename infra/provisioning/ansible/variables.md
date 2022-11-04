# Variables

## Variables

定義できる場所は

* `playbook.vars`
* `playbook.var_files`


`playbook.yaml`
```yaml
vars:
  xxx: aaa

var_files:
  - common.yaml
```

`common.yaml`
```text
key_1: var_1
key_2: var_2
```

### 参照

variableがdictの場合以下のように参照できる

* `{{ result.stat }}`
* `{{ result['key_1'][var] }}`
    * 参照するkeyに変数が使える

### Concatenate

```text
{{ server_name ~'.'~ domain_name }}
```

* `~'.'~`で変数を`.`でconcatenateできる

### Registering variables

コマンドの出力結果を変数に格納する

```yaml
- name: Capture output of whoami command
  command: whoami
  register: login
  # 失敗した場合の結果もみたいとき
  ignore_errors: true

- debug: var=login
- debug: msg="Logged in as user {{ login.stdout }}"
```

## Builtin variables

defaultで定義されているvariables

* `role_path` 現在のroleのdirectoryへのpath
