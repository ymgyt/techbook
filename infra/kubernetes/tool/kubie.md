# kubie

## Usage

```shell
# contextの切り替え
kubie ctx

# 現在のcontextの表示
kubie info ctx

# 現在のnamespaceの表示
kubie info ns
```

## Config file 

* `~/.kube/kubie.yaml`

```yaml
shell: nu
configs:
  include:
    - ~/.kube/config
    - ~/.kube/*.yml
    - ~/.kube/*.yaml
    - ~/.kube/*/kubeconfig
    # - ~/.kube/configs/*.yml
    # - ~/.kube/configs/*.yaml
    # - ~/.kube/kubie/*.yml
    # - ~/.kube/kubie/*.yaml
  # Exclude these globs.
  # Default: values listed below.
  # Note: kubie's own config file is always excluded.
  exclude:
    - ~/.kube/kubie.yaml
# Prompt settings.
prompt:
  disable: true
  show_depth: true
  zsh_use_rps1: false
  fish_use_rprompt: false
  xonsh_use_right_prompt: false
# Behavior
behavior:
  validate_namespaces: true
  print_context_in_exec: auto
hooks:
  start_ctx: >
    echo -en "\033]1; `kubie info ctx`|`kubie info ns` \007"

  stop_ctx: >
    echo -en "\033]1; $SHELL \007"
```

* あんまわかってない
