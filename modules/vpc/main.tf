resource "aws_vpc" "main"{
    cidr_block=var.vpccidr
    enable_dns_support=true
    enable_dns_hostnames=true
    tags=merge(
        var.tags,
        {
            Name="${var.prefix}-vpc"
        }
    )
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public"{
    count=length(var.publicsubnetcidr)
    vpc_id=aws_vpc.main.id
    cidr_block=element(var.publicsubnetcidr, count.index)
    availability_zone=element(data.aws_availability_zones.available.names, count.index)
    tags=merge(
        var.tags,
        {
            Name="${var.prefix}-public-subnet-${count.index + 1}"
        }
    )
}

resource "aws_subnet" "privateeks"{
    count=length(var.privateekssubnetcidr)
    vpc_id=aws_vpc.main.id
    cidr_block=var.privateekssubnetcidr[count.index]
    availability_zone=element(data.aws_availability_zones.available.names, count.index)
    tags=merge(
        var.tags,
        {
            Name="${var.prefix}-private-eks-subnet-${count.index + 1}"
        }
    )
}

resource "aws_subnet" "privaterds"{
    count=length(var.privaterdssubnetcidr)
    vpc_id=aws_vpc.main.id
    cidr_block=var.privaterdssubnetcidr[count.index]
    availability_zone=element(data.aws_availability_zones.available.names, count.index)
    tags=merge(
        var.tags,
        {
            Name="${var.prefix}-private-rds-subnet-${count.index + 1}"
        }
    )
}

resource "aws_internet_gateway" "main"{
    vpc_id=aws_vpc.main.id
    tags=merge(
        var.tags,
        {
            Name="${var.prefix}-igw"
        }
    )
}

resource "aws_route_table" "public"{
    vpc_id=aws_vpc.main.id
    route{
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.main.id
    }
    tags=merge(
        var.tags,
        {
            Name="${var.prefix}-public-rt"
        }
    )
    }

resource "aws_route_table_association" "public"{
    
    subnet_id=aws_subnet.public[0].id
    route_table_id=aws_route_table.public.id
}

resource "aws_eip" "nat"{
    
    domain="vpc"
    tags=merge(
        var.tags,
        {
            Name="${var.prefix}-nat-eip"
        }
    )
}

resource "aws_nat_gateway" "main"{
  
    allocation_id=aws_eip.nat.id
    subnet_id=aws_subnet.public[0].id
    tags=merge(
        var.tags,
        {
            Name="${var.prefix}-natgw"
        }
    )
}

resource "aws_route_table" "private_eks"{
    vpc_id=aws_vpc.main.id
  
    route{
        
        cidr_block="0.0.0.0/0"
        nat_gateway_id=aws_nat_gateway.main.id  
}
tags=merge(
        var.tags,
        {
            Name="${var.prefix}-private-eks-rt"
        }
    )
}

resource "aws_route_table_association" "private_eks"{
    count=2
    subnet_id=aws_subnet.privateeks[count.index].id
    
    route_table_id=aws_route_table.private_eks.id
}   

resource "aws_route_table" "private_rds"{
    vpc_id=aws_vpc.main.id

    route{
        
        cidr_block="0.0.0.0/0"
        nat_gateway_id=aws_nat_gateway.main.id  
}
tags=merge(
        var.tags,
        {
            Name="${var.prefix}-private-rds-rt"
        }
    )
}

resource "aws_route_table_association" "private_rds"{
    count=2
 
    subnet_id=aws_subnet.privaterds[count.index].id
    
    route_table_id=aws_route_table.private_rds.id
}