locals{
    defaulttags={
        project = "myproject" 
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