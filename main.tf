locals{
    defaulttags={
        project = "pharma" 
        environment=terraform.workspace
        }
    environments={
    dev={
        vpccidr="10.0.0.0/16"
        publicsubnetcidr=["10.0.1.0/24", "10.0.2.0/24"]
        privateekssubnetcidr=["10.0.3.0/24", "10.0.4.0/24"]
        privaterdssubnetcidr=["10.0.5.0/24", "10.0.6.0/24"]

    }
    qa={
        vpccidr="10.1.0.0/16"
        publicsubnetcidr=["10.1.1.0/24", "10.1.2.0/24"]
        privateekssubnetcidr=["10.1.3.0/24", "10.1.4.0/24"]
        privaterdssubnetcidr=["10.1.5.0/24", "10.1.6.0/24"]

    }
    prod={
        vpccidr="10.2.0.0/16"
        publicsubnetcidr=["10.2.1.0/24", "10.2.2.0/24"]
        privateekssubnetcidr=["10.2.3.0/24", "10.2.4.0/24"]
        privaterdssubnetcidr=["10.2.5.0/24", "10.2.6.0/24"]

    }


    }   
    
environment = local.environments[terraform.workspace]    
repositories=["api-gateway","auth-service","drug-catalog-service","inventory-service","supplier-service","manufacturing-service","notification-service","pharma-ui"]

}
module "vpc"{ 
    source="./modules/vpc"
    vpccidr=local.environment.vpccidr
    publicsubnetcidr=local.environment.publicsubnetcidr
    privateekssubnetcidr=local.environment.privateekssubnetcidr
    privaterdssubnetcidr=local.environment.privaterdssubnetcidr
    tags=local.defaulttags
    prefix="${local.defaulttags.project}-${local.defaulttags.environment}"
   
}

module "eks"{
    source="./modules/eks"
    prefix="${local.defaulttags.project}-${local.defaulttags.environment}"
    eks_subnet_ids=module.vpc.eks_subnet_ids
    min_size=var.minsize
    desired_size=var.desiredsize
    max_size=var.maxsize
    node_instance_type=[var.nodeinstance]
    tags=local.defaulttags
}

module "rds"{
    source="./modules/rds"
    prefix="${local.defaulttags.project}-${local.defaulttags.environment}"
      # Use all RDS subnet IDs for the DB subnet group
    tags=local.defaulttags
    vpc_id=module.vpc.vpcid
    allowed_cidr_blocks=module.vpc.eks_subnet_cidrs # Allow access from EKS subnets
    db_username=var.dbusername
    db_password=module.rds.master_password_arn 
    rds_subnet_group_name=module.vpc.rds_subnetgroup_name  # Use the first RDS subnet name for the DB subnet group
    instance_class=var.instanceclass

     
}

module "ecr"{
    source="./modules/ecr"
    ecrrepositoryname={for repo in local.repositories : repo.name => ecrrepositoryname}
    tags=local.defaulttags
    prefix = "${local.defaulttags.project}-${local.defaulttags.environment}"

}
