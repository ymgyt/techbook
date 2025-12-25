# ACM

1. certificate requestの作成

```hcl
resource "aws_acm_certificate" "foo" {
  domain_name       = "foo.ymgyt.io"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
```

2. DNSでdomainの所有を証明する(言われたレコードを作る)

```hcl
resource "aws_route53_record" "foo_verification" {
  for_each = {
    for dvo in aws_acm_certificate.foo.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = aws_route53_zone.my_zone.zone_id
}
```

3. certificateの完了まで待機する

```hcl
resource "aws_acm_certificate_validation" "foo" {
  certificate_arn         = aws_acm_certificate.foo.arn
  validation_record_fqdns = [for record in aws_route53_record.foo_verification : record.fqdn]
}
```
