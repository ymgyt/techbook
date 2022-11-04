# Fetch remote files

## `get_url`

```yaml
  ansible.builtin.get_url:
    url: "https://packages.cloud.google.com/apt/doc/apt-key.gpg"
    dest: "/usr/share/keyrings/kubernetes-archive-keyring.gpg"
    mode: "0644"
```
