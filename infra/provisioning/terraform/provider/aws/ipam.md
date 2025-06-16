# IPAM

```hcl
locals {
  # arrayのindexからCIDRを割り当てているので追加する際は
  # 必ず末尾に定義する
  # 割り当てるを解除する際はenable = falseを指定する
  #
  # 新規のregion追加時にはaws_vpc_ipam.default.operating_regionsへの追加も必要
  ipam_pools = [
    {
      region       = "ap-northeast-1",
      account_name = "foo",
      account_id   = "111122223333",
      enable       = true
    },
  ]

  ipam_cidrs = {
    for idx, pool in local.ipam_pools
    : "${pool.account_name}-${pool.region}" => {
      cidr         = cidrsubnet("10.0.0.0/8", 8, idx),
      account_id   = pool.account_id,
      account_name = pool.account_name,
      region       = pool.region,
    }
    if pool.enable
  }
}

resource "aws_vpc_ipam" "default" {
  cascade            = null
  description        = "Organization wide default IPAM instance"
  enable_private_gua = false
  tags = {
    Name       = "default"
  }
  tags_all = {
    Name       = "default"
  }
  tier = "advanced"
  operating_regions {
    region_name = "ap-northeast-1"
  }
}

resource "aws_vpc_ipam_pool" "root" {
  ipam_scope_id  = aws_vpc_ipam.default.private_default_scope_id
  address_family = "ipv4"
  tags           = { Name = "root‑10.0.0.0/8" }
}

resource "aws_vpc_ipam_pool_cidr" "root" {
  ipam_pool_id = aws_vpc_ipam_pool.root.id
  cidr         = "10.0.0.0/8"
}

resource "aws_vpc_ipam_pool" "accounts" {
  for_each = local.ipam_cidrs

  ipam_scope_id                     = aws_vpc_ipam.default.private_default_scope_id
  address_family                    = "ipv4"
  source_ipam_pool_id               = aws_vpc_ipam_pool.root.id
  allocation_default_netmask_length = 20
  locale                            = each.value.region
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_vpc_ipam_pool_cidr" "accounts" {
  for_each     = local.ipam_cidrs
  ipam_pool_id = aws_vpc_ipam_pool.accounts[each.key].id
  cidr         = each.value.cidr
}

# pool_idを共有先アカウントから見えるようにする
resource "aws_ssm_parameter" "ipam_pool_ids" {
  for_each = local.ipam_cidrs

  name        = "/ipam/${each.value.account_name}/${each.value.region}/pool-id"
  type        = "String"
  value       = aws_vpc_ipam_pool.accounts[each.key].id
  description = "IPAM Pool ID"
  overwrite   = true
  tier        = "Advanced"
}

resource "aws_ram_resource_share" "ipam_accounts" {
  for_each                  = aws_vpc_ipam_pool.accounts
  name                      = "ipam-${each.key}"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "ipam_accounts" {
  for_each           = aws_vpc_ipam_pool.accounts
  resource_share_arn = aws_ram_resource_share.ipam_accounts[each.key].arn
  resource_arn       = each.value.arn
}

resource "aws_ram_resource_association" "ipam_pool_id" {
  for_each           = aws_ssm_parameter.ipam_pool_ids
  resource_share_arn = aws_ram_resource_share.ipam_accounts[each.key].arn
  resource_arn       = each.value.arn
}

resource "aws_ram_principal_association" "ipam_accounts" {
  for_each           = local.ipam_cidrs
  resource_share_arn = aws_ram_resource_share.ipam_accounts[each.key].arn
  principal          = each.value.account_id
}
```


