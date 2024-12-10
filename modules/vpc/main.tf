terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws]
    }
  }
}

locals {
  nat_gateway_map = {
    for i, az in data.aws_availability_zones.available.names :
    az => {
      nat_subnet = i
    }
    if i < 2  # Limit to 2 NAT gateways
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = "${var.region_name}-vpc"
  })
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.region_name}-private-${count.index + 1}"
    Type = "Private"
  })
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.region_name}-public-${count.index + 1}"
    Type = "Public"
  })
}

resource "aws_nat_gateway" "main" {
  for_each = local.nat_gateway_map
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.value.nat_subnet].id

  tags = merge(var.common_tags, {
    Name = "${var.region_name}-nat-${each.key}"
  })

  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "nat" {
  for_each = local.nat_gateway_map
  domain   = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.region_name}-eip-${each.key}"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.region_name}-igw"
  })
}

resource "aws_route_table" "private" {
vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[data.aws_availability_zones.available.names[0]].id
  }

  dynamic "route" {
    for_each = var.extra_private_routes
    content {
      cidr_block         = route.value.cidr_block
      transit_gateway_id = route.value.transit_gateway_id
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.region_name}-private-rt"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.region_name}-public-rt"
  })
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web" {
  name        = "${var.region_name}-web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}