# Edit `/etc/hosts`

```yaml
- name: Run test
  run: |
    sudo echo "127.0.0.1 xxx" | sudo tee -a /etc/hosts
    sudo echo "127.0.0.1 yyy" | sudo tee -a /etc/hosts
```
