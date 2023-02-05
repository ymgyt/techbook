# Modules

## Test

### `uri`

```yaml
- name: "Test it! https://localhost:8443/index.html"
  delegate_to: localhost
  become: false
  uri:
    url: 'https://localhost:8443/index.html'
    validate_certs: false
    return_content: true
  register: this
  failed_when: "'Running on ' not in this.content"
```

