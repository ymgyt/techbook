# EC2

## Key pair

* `ssh-keygen`で生成したkeyをAWSに取り込む

```hcl
resource "aws_key_pair" "ssh" {
  key_name   = "twnana"
  public_key = "ssh-ed25519 XXX...YYY comment"
}
```
