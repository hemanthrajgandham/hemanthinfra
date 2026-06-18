locals{
    defaulttags={
        project = "pharma" 
        environment=terraform.workspace
        }
        
    
    
}
module "vpc"{
    source="./modules/vpc"
    vpccidr="10.0.0.0/16"
    publicsubnetcidr=["10.0.1.0/24", "10.0.2.0/24"]
    privateekssubnetcidr=["10.0.3.0/24", "10.0.4.0/24"]
    privaterdssubnetcidr=["10.0.5.0/24", "10.0.6.0/24"]
    tags=local.defaulttags
    prefix="${local.defaulttags.project}-${local.defaulttags.environment}"
   
}

module "eks"{
    source="./modules/eks"
    prefix="${local.defaulttags.project}-${local.defaulttags.environment}"
    eks_subnet_ids=module.vpc.eks_subnet_ids
    min_size=1
    desired_size=2
    max_size=3
    node_instance_type=["t3.small"]
    tags=local.defaulttags
}

module "rds"{
    source="./modules/rds"
    prefix="${local.defaulttags.project}-${local.defaulttags.environment}"
      # Use all RDS subnet IDs for the DB subnet group
    tags=local.defaulttags
    vpc_id=module.vpc.vpcid
    allowed_cidr_blocks=module.vpc.eks_subnet_cidrs # Allow access from EKS subnets
    db_username="pharmadb"
    db_password=module.rds.master_password_arn 
    rds_subnet_group_name=module.vpc.rds_subnetgroup_name  # Use the first RDS subnet name for the DB subnet group
    instance_class="db.t3.micro"

     
}