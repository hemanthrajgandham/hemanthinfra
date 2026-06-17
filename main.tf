locals{
    defaulttags={
        project = "myproject" 
        environment=terraform.workspace
        }
        
    
    
}
module "vpc"{
    source="./modules/vpc"
    vpccidr="10.0.0.0/16"
    projectname=local.defaulttags.project
    environment=local.defaulttags.environment
    publicsubnetcidr=["10.0.1.0/24", "10.0.2.0/24"]
    privateekssubnetcidr=["10.0.3.0/24", "10.0.4.0/24"]
    privaterdssubnetcidr=["10.0.5.0/24", "10.0.6.0/24"]
    tags=local.defaulttags
    prefix="${local.defaulttags.project}-${local.defaulttags.environment}"
   
}