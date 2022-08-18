################
## DEPLOY VPC ##
################

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name        = "VPC-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Create_by   = var.creator
    Project     = var.project
  }
}

######################
## INTERNET GATEWAY ##
######################

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "VPC-${var.project}-${var.env}"
    }
}

###################
## PUBLIC SUBNET ##
###################

resource "aws_subnet" "public_subnet" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.main.id
  cidr_block = "${var.prefixess_cidr}.${count.index}.0/24"
  map_public_ip_on_launch = var.publicIp
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name        = "Public-${var.azs[count.index]}-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Create_by   = var.creator
    Project     = var.project
  }
}

####################
## PRIVATE SUBNET ##
####################

resource "aws_subnet" "private_subnet" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.main.id
  cidr_block = "${var.prefixess_cidr}.${10+count.index}.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name        = "Private-${var.azs[count.index]}-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Create_by   = var.creator
    Project     = var.project
  }
}

#################
## BBDD SUBNET ##
#################

resource "aws_subnet" "bbdd_subnet" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.main.id
  cidr_block = "${var.prefixess_cidr}.${20+count.index}.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name        = "BBDD-${var.azs[count.index]}-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Create_by   = var.creator
    Project     = var.project
  }
}

################################################
## CREATE EIP AND ASSOCIATED WITH AN INSTANCE ##
################################################
resource "aws_eip" "nat_az" {
  count = "2"
  vpc      = true
  tags = {
    Name        = "EIP-NAT-${var.azs[count.index]}-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Create_by   = var.creator
    Project     = var.project
  }
}

########################
## CREATE NAT GATEWAY ##
########################

resource "aws_nat_gateway" "gw_az" {
  count = "2"
  allocation_id = aws_eip.nat_az[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name        = "NAT-${var.azs[count.index]}-${var.project}-${var.env}"
    Terraform   = var.terraform
    Environment = var.env
    Create_by   = var.creator
    Project     = var.project
  }
  depends_on = [
    aws_internet_gateway.igw,
    ]
}


#########################
## CREATE ROUTE TABLES ##
#########################

## PUBLIC ##
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.igw.id
    } 
    tags = {
      Name        = "Public-RT-${var.project}-${var.env}"
      Terraform   = var.terraform
      Environment = var.env
      Create_by   = var.creator
      Project     = var.project
  }
}
### ASSOCIATE
resource "aws_route_table_association" "public-subnet" {
    count = length(data.aws_availability_zones.available.names)
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

## PRIVATE AZA
resource "aws_route_table" "private_aza_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0" 
        nat_gateway_id = aws_nat_gateway.gw_az[0].id
    } 
    route {
        cidr_block  = "172.17.0.0/16"
        vpc_peering_connection_id = "pcx-010b064aaf676c8ec"
    }
    tags = {
      Name        = "Private-RT-${var.azs[0]}-${var.project}-${var.env}"
      Terraform   = var.terraform
      Environment = var.env
      Create_by   = var.creator
      Project     = var.project
  }
}
### ASSOCIATE
resource "aws_route_table_association" "private_aza-subnet"{
    subnet_id = aws_subnet.private_subnet[0].id
    route_table_id = aws_route_table.private_aza_rt.id
}
resource "aws_route_table_association" "bbdd_aza-subnet"{
    subnet_id = aws_subnet.bbdd_subnet[0].id
    route_table_id = aws_route_table.private_aza_rt.id
}


## PRIVATE AZB
resource "aws_route_table" "private_azb_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0" 
        nat_gateway_id = aws_nat_gateway.gw_az[1].id
    }
    route {
        cidr_block  = "172.17.0.0/16"
        vpc_peering_connection_id = "pcx-010b064aaf676c8ec"
    } 
    tags = {
      Name        = "Private-RT-${var.azs[1]}-${var.project}-${var.env}"
      Terraform   = var.terraform
      Environment = var.env
      Create_by   = var.creator
      Project     = var.project
  }
}
### ASSOCIATE
resource "aws_route_table_association" "private_azb-subnet"{
    subnet_id = aws_subnet.private_subnet[1].id
    route_table_id = aws_route_table.private_azb_rt.id
}
resource "aws_route_table_association" "bbdd_azb-subnet"{
    subnet_id = aws_subnet.bbdd_subnet[1].id
    route_table_id = aws_route_table.private_azb_rt.id
}

## PRIVATE AZC
resource "aws_route_table" "private_azc_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0" 
        nat_gateway_id = aws_nat_gateway.gw_az[1].id
    }
    route {
        cidr_block  = "172.17.0.0/16"
        vpc_peering_connection_id = "pcx-010b064aaf676c8ec"
    } 
    tags = {
      Name        = "Private-RT-${var.azs[2]}-${var.project}-${var.env}"
      Terraform   = var.terraform
      Environment = var.env
      Create_by   = var.creator
      Project     = var.project
  }
}
### ASSOCIATE
resource "aws_route_table_association" "private_azc-subnet"{
    subnet_id = aws_subnet.private_subnet[2].id
    route_table_id = aws_route_table.private_azc_rt.id
}
resource "aws_route_table_association" "bbdd_azc-subnet"{
    subnet_id = aws_subnet.bbdd_subnet[2].id
    route_table_id = aws_route_table.private_azc_rt.id
}

## PRIVATE AZD
resource "aws_route_table" "private_azd_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0" 
        nat_gateway_id = aws_nat_gateway.gw_az[1].id
    } 
    tags = {
      Name        = "Private-RT-${var.azs[3]}-${var.project}-${var.env}"
      Terraform   = var.terraform
      Environment = var.env
      Create_by   = var.creator
      Project     = var.project
  }
}
### ASSOCIATE
resource "aws_route_table_association" "private_azd-subnet"{
    subnet_id = aws_subnet.private_subnet[3].id
    route_table_id = aws_route_table.private_azd_rt.id
}
resource "aws_route_table_association" "bbdd_azd-subnet"{
    subnet_id = aws_subnet.bbdd_subnet[3].id
    route_table_id = aws_route_table.private_azd_rt.id
}

## PRIVATE AZE
resource "aws_route_table" "private_aze_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0" 
        nat_gateway_id = aws_nat_gateway.gw_az[1].id
    } 
    tags = {
      Name        = "Private-RT-${var.azs[4]}-${var.project}-${var.env}"
      Terraform   = var.terraform
      Environment = var.env
      Create_by   = var.creator
      Project     = var.project
  }
}
### ASSOCIATE
resource "aws_route_table_association" "private_aze-subnet"{
    subnet_id = aws_subnet.private_subnet[4].id
    route_table_id = aws_route_table.private_aze_rt.id
}
resource "aws_route_table_association" "bbdd_aze-subnet"{
    subnet_id = aws_subnet.bbdd_subnet[4].id
    route_table_id = aws_route_table.private_aze_rt.id
}

## PRIVATE AZF
resource "aws_route_table" "private_azf_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0" 
        nat_gateway_id = aws_nat_gateway.gw_az[1].id
    } 
    tags = {
      Name        = "Private-RT-${var.azs[5]}-${var.project}-${var.env}"
      Terraform   = var.terraform
      Environment = var.env
      Create_by   = var.creator
      Project     = var.project
  }
}
### ASSOCIATE
resource "aws_route_table_association" "private_azf-subnet"{
    subnet_id = aws_subnet.private_subnet[5].id
    route_table_id = aws_route_table.private_azf_rt.id
}
resource "aws_route_table_association" "bbdd_azf-subnet"{
    subnet_id = aws_subnet.bbdd_subnet[5].id
    route_table_id = aws_route_table.private_azf_rt.id
}