# Playbook

```yaml
---
- name: Name of play
  hosts:
    - app
    - front
  # should we sudo
  become: true
  gather_facts: false
  vars:
    tls_dir: /etc/nginx/ssl/
    key_file: nginx.key
    cert_file: nginx.crt
    conf_file: /etc/nginx/sites-available/default
    server_name: localhost

  handlers:
    - name: Restart nginx
      service:
        name: nginx
        state: restarted

  tasks:
    - name: Ensure nginx is installed
      package:
        name: nginx
        update_cache: true
      notify: Restart nginx
      
    - name: Setup int workers
      hosts:
        - master
        - worker
      roles:
      - role: k8s_node

```

## Loop

```yaml
- name: Copy TLS files
  copy:
    src: "{{ item }}"
    dest: "{{ tls_dir }}"
    mode: '0600'
  loop:
    - "{{ key_file }}"
    - "{{ cert_file }}"
```

* loop変数は`{{ item }}`で参照する

## Handlers

```yaml
# 定義
handlers:
  - name: Restart nginx
    service:
      name: nginx
      state: restarted
      
tasks:
  - name: Manage nginx config template
    template:
      src: nginx.conf.j2
      dest: "{{ conf_file }}"
      mode: '0644'
    # 呼び出し
    notify: Restart nginx
    # 付与するとtaskの実行中に呼び出される
    #meta: flush_handlers
```

* 条件つきで実行したいtaskのための仕組み
  * `notify`で呼び出されないと実行されない
  * おそらく呼び出し側のtaskでchangedになると呼んでくれる
   
* 呼び出し順は定義順。(notify順ではない)
  * 複数回notifyされても呼び出されるのは一度だけ。

* `meta: flush_handlers`
  * defaultではplayの最後に呼び出される

* 途中でtaskが失敗して、retryした場合、changedにならずrestartが走らないという罠に注意

## Role


```yaml
- name: Setup int workers
  hosts:
    - master
    - worker
  roles:
  - role: k8s_node
```

* `roles`で適用するroleを指定できる

## Check mode

```yaml
- name: this task will make changes to the system even in check mode
  command: "/something/to/run --even-in-check-mode"
  check_mode: no

- name: this task will always run under checkmode and not change the system
  lineinfile: line="important config" dest=/path/to/myconfig.conf state=present
  check_mode: yes
```

* `check_mode: yes`
  * 常に(実行時の`--check` flagによらずに)当該moduleをcheck modeで動作させる。
* `check_mode: no`
  * `--check`が指定され、check_modeで動作している場合でもcheck modeを無効にする。
  * `command` moduleはcheck_modeでは飛ばされるのでこれを指定してcheck_modeでも動くようにする。

## Changed when

```yaml
- name: ls
  shell: ls
  changed_when: false
```

serverのchangedの判定を指定する。

## Variables

variables.md

