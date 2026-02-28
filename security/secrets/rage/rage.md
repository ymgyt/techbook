# rage

## Usage

1. Generate key

```sh
rage-keygen -o ~/.config/age/keys.txt

# 公開鍵を表示
rage-keygen -y ~/.config/age/keys.txt
```

2. Encrypt

```nu
let recipient = "age1XXX...YYY"
rage -r $recipient cred.txt -o out.age
```

3. Decrypt

```sh
rage -d -i ~/.config/age/keys.txt out.age
```
