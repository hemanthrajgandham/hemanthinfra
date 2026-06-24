output "vpcid"{
    value=aws_vpc.main.id
}
output "eks_subnet_ids"{
    value=aws_subnet.privateeks[*].id
}

output "rds_subnet_ids"{
    value=aws_subnet.privaterds[*].id
}

output "rds_subnetgroup_name"{
    value=aws_db_subnet_group.rds_subnet_group.name
}

output "eks_subnet_cidrs"{
    value=aws_subnet.privateeks[*].cidr_block
}