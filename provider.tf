terraform{

  required_providers{
    aws={
      source="hashicorp/aws"
      version="~>5.0"
    }
  }
  backend "S3"{
    bucket="zen-pharma-terraform-state-hemanthrajgandham"
    key="envs/${terraform.workspace}/terraform.tfstate"
    encrypt=true
    use_lockfile=true
    region="us-east-1"
  
  }
}

provider "aws"{
  region="us-east-1"
}