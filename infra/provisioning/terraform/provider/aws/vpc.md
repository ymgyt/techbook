# VPC

## Public Subnet

```hcl
locals {
  vpc_name = "foo"
}

resource "aws_vpc" "foo" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = local.vpc_name
  }
}

locals {
  public_subnets = {
    "ap-northeast-1a" = {
      "cidr" = "10.0.1.0/24"
    },
    "ap-northeast-1c" = {
      "cidr" = "10.0.2.0/24"
    },
    "ap-northeast-1d" = {
      "cidr" = "10.0.3.0/24"
    },
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id            = aws_vpc.foo.id
  availability_zone = each.key
  cidr_block        = each.value.cidr

  tags = {
    Name = format("${local.vpc_name}-public-${each.key}")
  }
}

resource "aws_internet_gateway" "foo" {
  vpc_id = aws_vpc.foo.id
  tags = {
    Name = local.vpc_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.foo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.foo.id
  }

  tags = {
    Name = local.vpc_name
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
```

* Public subnet == 紐づくroute tableにinternet gatewayへのrouteがある
* subnetに明示的にroute tableを指定しないとdefaultのroute tableになる
