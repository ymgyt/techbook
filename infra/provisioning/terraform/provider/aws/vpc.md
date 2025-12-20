# VPC

## Public/Private Subnets

variables.tf
```hcl
variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "nat_mode" {
  type = string
  # single | per_az
  default = "single"

  validation {
    condition     = contains(["single", "per_az"], var.nat_mode)
    error_message = "nat_mode must be 'single' or 'per_az'"
  }
}
```

vpc.tf
```hcl

data "aws_availability_zones" "this" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# CIDR
# VPC    : 10.0.0.0/16
# Private: 10.0.0.0/20
# Public : 10.0.240.0/22

# 10.0.240.0 は10.0.0.0/20の最後のsubnet
# これをpublic用に予約している

locals {
  vpc_name           = var.vpc_name
  vpc_cidr           = "10.0.0.0/16"
  az_count           = 3
  public_subnet_cidr = "10.0.240.0/20"

  azs           = slice(data.aws_availability_zones.this.names, 0, local.az_count)
  single_nat_az = local.azs[0]
  nat_azs       = var.nat_mode == "single" ? [local.single_nat_az] : local.azs

  private_subnets = {
    for i, az in local.azs :
    az => {
      cidr = cidrsubnet(local.vpc_cidr, 4, i)
    }
  }

  public_subnets = {
    for i, az in local.azs :
    az => {
      cidr = cidrsubnet(local.public_subnet_cidr, 2, i)
    }
  }
}

# ---
# VPC
# ---
resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = local.vpc_name
  }
}

# -------
# Subnets
# -------
resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = each.value.cidr

  tags = {
    Name = format("${local.vpc_name}-private-${each.key}")
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = each.value.cidr

  tags = {
    Name = format("${local.vpc_name}-public-${each.key}")
  }
}

# ---
# IGW
# ---
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = local.vpc_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${local.vpc_name}-public"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# ---
# NAT
# ---
resource "aws_eip" "nat" {
  for_each = toset(local.nat_azs)

  domain = "vpc"
  tags = {
    Name = "${local.vpc_name}-nat-${each.key}"
  }
}

resource "aws_nat_gateway" "this" {
  for_each = toset(local.nat_azs)

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${local.vpc_name}-${each.key}"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private_single" {
  count  = var.nat_mode == "single" ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[local.single_nat_az].id
  }

  tags = {
    Name = "${local.vpc_name}-private"
  }
}

resource "aws_route_table" "private_per_az" {
  for_each = var.nat_mode == "per_az" ? toset(local.azs) : toset([])

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }

  tags = {
    Name = "${local.vpc_name}-private-${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id = each.value.id

  route_table_id = (
    var.nat_mode == "single"
    ? aws_route_table.private_single[0].id
    : aws_route_table.private_per_az[each.key].id
  )
}
```
