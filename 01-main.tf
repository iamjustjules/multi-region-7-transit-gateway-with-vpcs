locals {
  regions = {
    tokyo      = { cidr = "10.100.0.0/16", region = "ap-northeast-1" }
    new_york   = { cidr = "10.101.0.0/16", region = "us-east-1" }
    london     = { cidr = "10.102.0.0/16", region = "eu-west-1" }
    sao_paulo  = { cidr = "10.103.0.0/16", region = "sa-east-1" }
    australia  = { cidr = "10.104.0.0/16", region = "ap-southeast-2" }
    hong_kong  = { cidr = "10.105.0.0/16", region = "ap-east-1" }
    california = { cidr = "10.106.0.0/16", region = "us-west-1" }
  }

  # Hub region (Tokyo)
  hub_region = "tokyo"
  
  # Spoke regions (all except Tokyo)
  spoke_regions = {
    for k, v in local.regions : k => v
    if k != local.hub_region
  }

  common_tags = {
    Project     = "TMMC-Teledoctor"
    Environment = "Stage1"
    Terraform   = "true"
  }
}

locals {
  provider_aliases = {
    tokyo      = "tokyo"
    new_york   = "new_york"
    london     = "london"
    sao_paulo  = "sao_paulo"
    australia  = "australia"
    hong_kong  = "hong_kong"
    california = "california"
  }
}

# VPCs for each region
module "vpc_tokyo" {
  source = "./modules/vpc"
  providers = {
    aws = aws.tokyo
  }
  vpc_cidr = local.regions.tokyo.cidr
  region_name = "tokyo"
  
  common_tags = {
    Project     = "TMMC-Teledoctor"
    Environment = "Stage1"
    Terraform   = "true"
  }
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
  public_cidr_blocks = {
    public1 = "10.100.0.0/24"
    public2 = "10.100.1.0/24"
  }
  private_cidr_blocks = {
    private1 = "10.100.10.0/24"
    private2 = "10.100.11.0/24"
  }
}

module "vpc_new_york" {
  source = "./modules/vpc"
  providers = {
    aws = aws.new_york
  }
  vpc_cidr = local.regions.new_york.cidr
  region_name = "new-york"
  
  common_tags = {
    Project     = "TMMC-Teledoctor"
    Environment = "Stage1"
    Terraform   = "true"
  }

  availability_zones = ["us-east-1a", "us-east-1b"]
  public_cidr_blocks = {
    public1 = "10.101.0.0/24"
    public2 = "10.101.1.0/24"
  }
  private_cidr_blocks = {
    private1 = "10.101.10.0/24"
    private2 = "10.101.11.0/24"
  }
}

module "vpc_london" {
  source = "./modules/vpc"
  providers = {
    aws = aws.london
  }
  vpc_cidr = local.regions.london.cidr
  region_name = "london"
  
  common_tags = {
    Project     = "TMMC-Teledoctor"
    Environment = "Stage1"
    Terraform   = "true"
  }

  availability_zones = ["eu-west-1a", "eu-west-1b"]
  public_cidr_blocks = {
    public1 = "10.102.0.0/24"
    public2 = "10.102.1.0/24"
  }
  private_cidr_blocks = {
    private1 = "10.102.10.0/24"
    private2 = "10.102.11.0/24"
  }
}

module "vpc_sao_paulo" {
  source = "./modules/vpc"
  providers = {
    aws = aws.sao_paulo
  }
  vpc_cidr = local.regions.sao_paulo.cidr
  region_name = "sao-paulo"
  
    common_tags = {
    Project     = "TMMC-Teledoctor"
    Environment = "Stage1"
    Terraform   = "true"
  }
  
  availability_zones = ["sa-east-1a", "sa-east-1c"]
  public_cidr_blocks = {
    public1 = "10.103.0.0/24"
    public2 = "10.103.1.0/24"
  }
  private_cidr_blocks = {
    private1 = "10.103.10.0/24"
    private2 = "10.103.11.0/24"
  }
}

module "vpc_australia" {
  source = "./modules/vpc"
  providers = {
    aws = aws.australia
  }
  vpc_cidr = local.regions.australia.cidr
  region_name = "australia"

  common_tags = {
    Project     = "TMMC-Teledoctor"
    Environment = "Stage1"
    Terraform   = "true"
  }

  availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]
  public_cidr_blocks = {
    public1 = "10.104.0.0/24"
    public2 = "10.104.1.0/24"
  }
  private_cidr_blocks = {
    private1 = "10.104.10.0/24"
    private2 = "10.104.11.0/24"
  }
}

module "vpc_hong_kong" {
  source = "./modules/vpc"
  providers = {
    aws = aws.hong_kong
  }
  vpc_cidr = local.regions.hong_kong.cidr
  region_name = "hong-kong"
  
  common_tags = {
    Project     = "TMMC-Teledoctor"
    Environment = "Stage1"
    Terraform   = "true"
  }

  availability_zones = ["ap-east-1a", "ap-east-1b"]
  public_cidr_blocks = {
    public1 = "10.105.0.0/24"
    public2 = "10.105.1.0/24"
  }
  private_cidr_blocks = {
    private1 = "10.105.10.0/24"
    private2 = "10.105.11.0/24"
  }
}

module "vpc_california" {
  source = "./modules/vpc"
  providers = {
    aws = aws.california
  }
  vpc_cidr = local.regions.california.cidr
  region_name = "california"
  
  common_tags = {
    Project     = "TMMC-Teledoctor"
    Environment = "Stage1"
    Terraform   = "true"
  }

  availability_zones = ["us-west-1a", "us-west-1c"]
  public_cidr_blocks = {
    public1 = "10.106.0.0/24"
    public2 = "10.106.1.0/24"
  }
  private_cidr_blocks = {
    private1 = "10.106.10.0/24"
    private2 = "10.106.11.0/24"
  }
}

# Hub accepts peering requests
# resource "aws_ec2_transit_gateway_peering_attachment_accepter" "hub_accepter" {
#   for_each = aws_ec2_transit_gateway_peering_attachment.spoke_to_hub
  
#   provider = aws.tokyo
  
#   transit_gateway_attachment_id = each.value.id
  
#   tags = merge(local.common_tags, {
#     Name = "Tokyo-${title(each.key)}-Peering-Accepter"
#   })
# }

# Tokyo (Hub) Transit Gateway
resource "aws_ec2_transit_gateway" "hub" {
  provider = aws.tokyo
  
  description = "Tokyo Hub Transit Gateway"
  amazon_side_asn = 64512
  
  tags = merge(local.common_tags, {
    Name = "Tokyo-Hub-TGW"
  })
}

# Individual Spoke Gateways
resource "aws_ec2_transit_gateway" "new_york" {
  provider = aws.new_york
  description = "New York Spoke Transit Gateway"
  amazon_side_asn = 64513
  tags = merge(local.common_tags, { Name = "New-York-Spoke-TGW" })
}

resource "aws_ec2_transit_gateway" "london" {
  provider = aws.london
  description = "London Spoke Transit Gateway"
  amazon_side_asn = 64514
  tags = merge(local.common_tags, { Name = "London-Spoke-TGW" })
}

resource "aws_ec2_transit_gateway" "sao_paulo" {
  provider = aws.sao_paulo
  description = "Sao Paulo Spoke Transit Gateway"
  amazon_side_asn = 64515
  tags = merge(local.common_tags, { Name = "SaoPaulo-Spoke-TGW" })
}

resource "aws_ec2_transit_gateway" "australia" {
  provider = aws.australia
  description = "Australia Spoke Transit Gateway"
  amazon_side_asn = 64516
  tags = merge(local.common_tags, { Name = "Australia-Spoke-TGW" })
}

resource "aws_ec2_transit_gateway" "hong_kong" {
  provider = aws.hong_kong
  description = "Hong Kong Spoke Transit Gateway"
  amazon_side_asn = 64517
  tags = merge(local.common_tags, { Name = "HongKong-Spoke-TGW" })
}

resource "aws_ec2_transit_gateway" "california" {
  provider = aws.california
  description = "California Spoke Transit Gateway"
  amazon_side_asn = 64518
  tags = merge(local.common_tags, { Name = "California-Spoke-TGW" })
}

# Routes in hub to reach spokes
# Routes from Tokyo to New York
resource "aws_ec2_transit_gateway_route" "tokyo_to_new_york" {
  provider = aws.tokyo
  destination_cidr_block = local.regions.new_york.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.new_york_to_tokyo.id

depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.new_york,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.new_york,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.new_york,
    aws_ec2_transit_gateway_peering_attachment.new_york_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_new_york
  ]
}

# Routes from New York to Tokyo
resource "aws_ec2_transit_gateway_route" "new_york_to_tokyo" {
  provider = aws.new_york
  destination_cidr_block = local.regions.tokyo.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.new_york.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.new_york_to_tokyo.id

depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.new_york,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.new_york,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.new_york,
    aws_ec2_transit_gateway_peering_attachment.new_york_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_new_york
  ]
}

# Routes from Tokyo to London
resource "aws_ec2_transit_gateway_route" "tokyo_to_london" {
  provider = aws.tokyo
  destination_cidr_block = local.regions.london.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.london_to_tokyo.id

depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.london,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.london,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.london,
    aws_ec2_transit_gateway_peering_attachment.london_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_london
  ]
}

# Routes from London to Tokyo
resource "aws_ec2_transit_gateway_route" "london_to_tokyo" {
  provider = aws.london
  destination_cidr_block = local.regions.tokyo.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.london.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.london_to_tokyo.id

depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.london,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.london,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.london,
    aws_ec2_transit_gateway_peering_attachment.london_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_london
  ]
}

# Routes from Tokyo to Sao Paulo
resource "aws_ec2_transit_gateway_route" "tokyo_to_sao_paulo" {
  provider = aws.tokyo
  destination_cidr_block = local.regions.sao_paulo.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.sao_paulo_to_tokyo.id

depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.sao_paulo,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.sao_paulo,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.sao_paulo,
    aws_ec2_transit_gateway_peering_attachment.sao_paulo_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_sao_paulo
  ]
}    

# Routes from Sao Paulo to Tokyo
resource "aws_ec2_transit_gateway_route" "sao_paulo_to_tokyo" {
  provider = aws.sao_paulo
  destination_cidr_block = local.regions.tokyo.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.sao_paulo.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.sao_paulo_to_tokyo.id

depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.sao_paulo,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.sao_paulo,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.sao_paulo,
    aws_ec2_transit_gateway_peering_attachment.sao_paulo_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_sao_paulo
  ]
}

# Routes from Tokyo to Australia
resource "aws_ec2_transit_gateway_route" "tokyo_to_australia" {
  provider = aws.tokyo
  destination_cidr_block = local.regions.australia.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.australia_to_tokyo.id
  
depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.australia,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.australia,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.australia,
    aws_ec2_transit_gateway_peering_attachment.australia_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_australia
  ]
}

# Routes from Australia to Tokyo
resource "aws_ec2_transit_gateway_route" "australia_to_tokyo" {
  provider = aws.australia
  destination_cidr_block = local.regions.tokyo.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.australia.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.australia_to_tokyo.id

depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.australia,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.australia,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.australia,
    aws_ec2_transit_gateway_peering_attachment.australia_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_australia
  ]
}

# Routes from Tokyo to Hong Kong
resource "aws_ec2_transit_gateway_route" "tokyo_to_hong_kong" {
  provider = aws.tokyo
  destination_cidr_block = local.regions.hong_kong.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.hong_kong_to_tokyo.id

depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.hong_kong,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.hong_kong,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.hong_kong,
    aws_ec2_transit_gateway_peering_attachment.hong_kong_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_hong_kong
  ]
}

# Routes from Hong Kong to Tokyo
resource "aws_ec2_transit_gateway_route" "hong_kong_to_tokyo" {
  provider = aws.hong_kong
  destination_cidr_block = local.regions.tokyo.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hong_kong.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.hong_kong_to_tokyo.id

depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.hong_kong,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.hong_kong,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.hong_kong,
    aws_ec2_transit_gateway_peering_attachment.hong_kong_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_hong_kong
  ]
}

# Routes from Tokyo to California
resource "aws_ec2_transit_gateway_route" "tokyo_to_california" {
  provider = aws.tokyo
  destination_cidr_block = local.regions.california.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.california_to_tokyo.id

depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.california,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.california,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.california,
    aws_ec2_transit_gateway_peering_attachment.california_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_california
  ]
}  

# Routes from California to Tokyo
resource "aws_ec2_transit_gateway_route" "california_to_tokyo" {
  provider = aws.california
  destination_cidr_block = local.regions.tokyo.cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.california.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.california_to_tokyo.id

depends_on = [
    aws_ec2_transit_gateway.hub,
    aws_ec2_transit_gateway.california,
    aws_ec2_transit_gateway_vpc_attachment.tokyo,
    aws_ec2_transit_gateway_vpc_attachment.california,
    aws_ec2_transit_gateway_route_table.tokyo,
    aws_ec2_transit_gateway_route_table.california,
    aws_ec2_transit_gateway_peering_attachment.california_to_tokyo,
    aws_ec2_transit_gateway_peering_attachment_accepter.tokyo_california
  ]
}

# Transit gateway route tables
resource "aws_ec2_transit_gateway_route_table" "tokyo" {
  provider = aws.tokyo
  transit_gateway_id = aws_ec2_transit_gateway.hub.id
  tags = merge(local.common_tags, { Name = "Tokyo-TGW-Route-Table" })

  depends_on = [
    aws_ec2_transit_gateway.hub
  ]
}

resource "aws_ec2_transit_gateway_route_table" "new_york" {
  provider = aws.new_york
  transit_gateway_id = aws_ec2_transit_gateway.new_york.id
  tags = merge(local.common_tags, { Name = "New-York-TGW-Route-Table" })

  depends_on = [
    aws_ec2_transit_gateway.hub
  ]

}

resource "aws_ec2_transit_gateway_route_table" "london" {
  provider = aws.london
  transit_gateway_id = aws_ec2_transit_gateway.london.id
  tags = merge(local.common_tags, { Name = "London-TGW-Route-Table" })

  depends_on = [
    aws_ec2_transit_gateway.hub
  ]
}

resource "aws_ec2_transit_gateway_route_table" "sao_paulo" {
  provider = aws.sao_paulo
  transit_gateway_id = aws_ec2_transit_gateway.sao_paulo.id
  tags = merge(local.common_tags, { Name = "SaoPaulo-TGW-Route-Table" })

  depends_on = [
    aws_ec2_transit_gateway.hub
  ]
}

resource "aws_ec2_transit_gateway_route_table" "australia" {
  provider = aws.australia
  transit_gateway_id = aws_ec2_transit_gateway.australia.id
  tags = merge(local.common_tags, { Name = "Australia-TGW-Route-Table" })

  depends_on = [
    aws_ec2_transit_gateway.hub
  ]
}

resource "aws_ec2_transit_gateway_route_table" "hong_kong" {
  provider = aws.hong_kong
  transit_gateway_id = aws_ec2_transit_gateway.hong_kong.id
  tags = merge(local.common_tags, { Name = "HongKong-TGW-Route-Table" })

  depends_on = [
    aws_ec2_transit_gateway.hub
  ]
}

resource "aws_ec2_transit_gateway_route_table" "california" {
  provider = aws.california
  transit_gateway_id = aws_ec2_transit_gateway.california.id
  tags = merge(local.common_tags, { Name = "California-TGW-Route-Table" })

  depends_on = [
    aws_ec2_transit_gateway.hub
  ]
}

# Route table associations
resource "aws_ec2_transit_gateway_route_table_association" "tokyo" {
  provider = aws.tokyo
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tokyo.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo.id
  replace_existing_association   = true  

  depends_on = [
   aws_ec2_transit_gateway_vpc_attachment.tokyo,
   aws_ec2_transit_gateway_route_table.tokyo
 ] 
}

resource "aws_ec2_transit_gateway_route_table_association" "new_york" {
  provider = aws.new_york
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.new_york.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.new_york.id
  replace_existing_association   = true

  depends_on = [
   aws_ec2_transit_gateway_vpc_attachment.new_york,
   aws_ec2_transit_gateway_route_table.new_york
 ]

lifecycle {
    replace_triggered_by = [
      aws_ec2_transit_gateway_vpc_attachment.new_york
    ]
  }

}

resource "aws_ec2_transit_gateway_route_table_association" "london" {
  provider = aws.london
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.london.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.london.id
  replace_existing_association   = true

  depends_on = [
   aws_ec2_transit_gateway_vpc_attachment.london,
   aws_ec2_transit_gateway_route_table.london
 ]

 lifecycle {
    replace_triggered_by = [
      aws_ec2_transit_gateway_vpc_attachment.london
    ]
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "sao_paulo" {
  provider = aws.sao_paulo
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.sao_paulo.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.sao_paulo.id
  replace_existing_association   = true

  depends_on = [
   aws_ec2_transit_gateway_vpc_attachment.sao_paulo,
   aws_ec2_transit_gateway_route_table.sao_paulo
 ]

 lifecycle {
    replace_triggered_by = [
      aws_ec2_transit_gateway_vpc_attachment.sao_paulo
    ]
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "australia" {
  provider = aws.australia
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.australia.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.australia.id
  replace_existing_association   = true

  depends_on = [
   aws_ec2_transit_gateway_vpc_attachment.australia,
   aws_ec2_transit_gateway_route_table.australia
 ]

 lifecycle {
    replace_triggered_by = [
      aws_ec2_transit_gateway_vpc_attachment.australia
    ]
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "hong_kong" {
  provider = aws.hong_kong
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.hong_kong.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hong_kong.id
  replace_existing_association   = true

  depends_on = [
   aws_ec2_transit_gateway_vpc_attachment.hong_kong,
   aws_ec2_transit_gateway_route_table.hong_kong
 ]

 lifecycle {
    replace_triggered_by = [
      aws_ec2_transit_gateway_vpc_attachment.hong_kong
    ]
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "california" {
  provider = aws.california
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.california.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.california.id
  replace_existing_association   = true

  depends_on = [
   aws_ec2_transit_gateway_vpc_attachment.california,
   aws_ec2_transit_gateway_route_table.california
 ]

 lifecycle {
    replace_triggered_by = [
      aws_ec2_transit_gateway_vpc_attachment.california
    ]
  }
}

# VPC attachments to transit gateways
resource "aws_ec2_transit_gateway_vpc_attachment" "tokyo" {
  provider = aws.tokyo
  transit_gateway_id = aws_ec2_transit_gateway.hub.id
  vpc_id = module.vpc_tokyo.vpc_id
  subnet_ids = module.vpc_tokyo.private_subnet_ids
  tags = merge(local.common_tags, { Name = "Tokyo-TGW-Attachment" })

  depends_on = [aws_ec2_transit_gateway.hub]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "new_york" {
  provider = aws.new_york
  transit_gateway_id = aws_ec2_transit_gateway.new_york.id
  vpc_id = module.vpc_new_york.vpc_id
  subnet_ids = module.vpc_new_york.private_subnet_ids
  tags = merge(local.common_tags, { Name = "New-York-TGW-Attachment" })

  depends_on = [aws_ec2_transit_gateway.hub]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "london" {
  provider = aws.london
  transit_gateway_id = aws_ec2_transit_gateway.london.id
  vpc_id = module.vpc_london.vpc_id
  subnet_ids = module.vpc_london.private_subnet_ids
  tags = merge(local.common_tags, { Name = "London-TGW-Attachment" })

  depends_on = [aws_ec2_transit_gateway.hub]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "sao_paulo" {
  provider = aws.sao_paulo
  transit_gateway_id = aws_ec2_transit_gateway.sao_paulo.id
  vpc_id = module.vpc_sao_paulo.vpc_id
  subnet_ids = module.vpc_sao_paulo.private_subnet_ids
  tags = merge(local.common_tags, { Name = "SaoPaulo-TGW-Attachment" })

  depends_on = [aws_ec2_transit_gateway.hub]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "australia" {
  provider = aws.australia
  transit_gateway_id = aws_ec2_transit_gateway.australia.id
  vpc_id = module.vpc_australia.vpc_id
  subnet_ids = module.vpc_australia.private_subnet_ids
  tags = merge(local.common_tags, { Name = "Australia-TGW-Attachment" })

  depends_on = [aws_ec2_transit_gateway.hub]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "hong_kong" {
  provider = aws.hong_kong
  transit_gateway_id = aws_ec2_transit_gateway.hong_kong.id
  vpc_id = module.vpc_hong_kong.vpc_id
  subnet_ids = module.vpc_hong_kong.private_subnet_ids
  tags = merge(local.common_tags, { Name = "HongKong-TGW-Attachment" })

  depends_on = [aws_ec2_transit_gateway.hub]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "california" {
  provider = aws.california
  transit_gateway_id = aws_ec2_transit_gateway.california.id
  vpc_id = module.vpc_california.vpc_id
  subnet_ids = module.vpc_california.private_subnet_ids
  tags = merge(local.common_tags, { Name = "California-TGW-Attachment" })

  depends_on = [aws_ec2_transit_gateway.hub]
}

# Peering attachments from hub to spokes
# New York to Tokyo
resource "aws_ec2_transit_gateway_peering_attachment" "new_york_to_tokyo" {
  provider = aws.new_york
  
  transit_gateway_id      = aws_ec2_transit_gateway.new_york.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.hub.id
  peer_region            = "ap-northeast-1"
  peer_account_id        = var.peer_account_id
  
  tags = merge(local.common_tags, {
    Name = "New-York-Tokyo-Peering"
  })

  depends_on = [
   aws_ec2_transit_gateway.hub,
   aws_ec2_transit_gateway.new_york
 ]
}

# London to Tokyo
resource "aws_ec2_transit_gateway_peering_attachment" "london_to_tokyo" {
  provider = aws.london
  
  transit_gateway_id      = aws_ec2_transit_gateway.london.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.hub.id
  peer_region            = "ap-northeast-1"
  peer_account_id        = var.peer_account_id
  
  tags = merge(local.common_tags, {
    Name = "London-Tokyo-Peering"
  })

  depends_on = [
   aws_ec2_transit_gateway.hub,
   aws_ec2_transit_gateway.london
 ]

}

# Sao Paulo to Tokyo
resource "aws_ec2_transit_gateway_peering_attachment" "sao_paulo_to_tokyo" {
  provider = aws.sao_paulo
  
  transit_gateway_id      = aws_ec2_transit_gateway.sao_paulo.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.hub.id
  peer_region            = "ap-northeast-1"
  peer_account_id        = var.peer_account_id
  
  tags = merge(local.common_tags, {
    Name = "Sao-Paulo-Tokyo-Peering"
  })

  depends_on = [
   aws_ec2_transit_gateway.hub,
   aws_ec2_transit_gateway.sao_paulo
 ]
}

# Australia to Tokyo
resource "aws_ec2_transit_gateway_peering_attachment" "australia_to_tokyo" {
  provider = aws.australia
  
  transit_gateway_id      = aws_ec2_transit_gateway.australia.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.hub.id
  peer_region            = "ap-northeast-1"
  peer_account_id        = var.peer_account_id
  
  tags = merge(local.common_tags, {
    Name = "Australia-Tokyo-Peering"
  })

  depends_on = [
   aws_ec2_transit_gateway.hub,
   aws_ec2_transit_gateway.australia
 ]

}

# Hong Kong to Tokyo
resource "aws_ec2_transit_gateway_peering_attachment" "hong_kong_to_tokyo" {
  provider = aws.hong_kong
  
  transit_gateway_id      = aws_ec2_transit_gateway.hong_kong.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.hub.id
  peer_region            = "ap-northeast-1"
  peer_account_id        = var.peer_account_id
  
  tags = merge(local.common_tags, {
    Name = "Hong-Kong-Tokyo-Peering"
  })

  depends_on = [
   aws_ec2_transit_gateway.hub,
   aws_ec2_transit_gateway.hong_kong
 ]

}

# California to Tokyo
resource "aws_ec2_transit_gateway_peering_attachment" "california_to_tokyo" {
  provider = aws.california
  
  transit_gateway_id      = aws_ec2_transit_gateway.california.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.hub.id
  peer_region            = "ap-northeast-1"
  peer_account_id        = var.peer_account_id
  
  tags = merge(local.common_tags, {
    Name = "California-Tokyo-Peering"
  })

  depends_on = [
   aws_ec2_transit_gateway.hub,
   aws_ec2_transit_gateway.california
 ]
}

# Peering attachments from spokes to hub
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tokyo_new_york" {
  provider = aws.tokyo
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.new_york_to_tokyo.id
  tags = merge(local.common_tags, { Name = "Tokyo-New-York-Peering-Accepter" })

  depends_on = [aws_ec2_transit_gateway_peering_attachment.new_york_to_tokyo]
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tokyo_london" {
  provider = aws.tokyo
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.london_to_tokyo.id
  tags = merge(local.common_tags, { Name = "Tokyo-London-Peering-Accepter" })

  depends_on = [aws_ec2_transit_gateway_peering_attachment.london_to_tokyo]
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tokyo_sao_paulo" {
  provider = aws.tokyo
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.sao_paulo_to_tokyo.id
  tags = merge(local.common_tags, { Name = "Tokyo-Sao-Paulo-Peering-Accepter" })

  depends_on = [aws_ec2_transit_gateway_peering_attachment.sao_paulo_to_tokyo]
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tokyo_australia" {
  provider = aws.tokyo
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.australia_to_tokyo.id
  tags = merge(local.common_tags, { Name = "Tokyo-Australia-Peering-Accepter" })

  depends_on = [aws_ec2_transit_gateway_peering_attachment.australia_to_tokyo]
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tokyo_hong_kong" {
  provider = aws.tokyo
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.hong_kong_to_tokyo.id
  tags = merge(local.common_tags, { Name = "Tokyo-Hong-Kong-Peering-Accepter" })

  depends_on = [aws_ec2_transit_gateway_peering_attachment.hong_kong_to_tokyo]
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tokyo_california" {
  provider = aws.tokyo
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.california_to_tokyo.id
  tags = merge(local.common_tags, { Name = "Tokyo-California-Peering-Accepter" })

  depends_on = [aws_ec2_transit_gateway_peering_attachment.california_to_tokyo]
}

# Deploy syslog only in Tokyo
module "syslog" {
  source = "./modules/syslog"
  providers = {
    aws = aws.tokyo
  }
  vpc_id     = module.vpc_tokyo.vpc_id
  subnet_id  = module.vpc_tokyo.private_subnet_ids[0]
  vpc_cidrs  = { for k, v in local.regions : k => v.cidr }
  common_tags = local.common_tags
}
