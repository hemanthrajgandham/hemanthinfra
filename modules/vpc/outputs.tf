output "vpcid"{
    value=aws_vpc.main.id
}
output "eks_subnet_ids"{
    value=aws_subnet.privateeks[*].id
}