# Role

* playbookをdecomposeする役割を担う
  * playbookの粒度を小さくして再利用性を高められる

## Directory structure

### tasks

* `main.yaml`がentry point

```yaml
- name: Install kube tools
  ansible.builtin.include_tasks: install_kube_tools.yaml
```

* `tasks`配下でさらにtasksごとにfileをきってincludeできる
