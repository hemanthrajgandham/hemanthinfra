terraform{
backend "s3"{
    bucket="zen-pharma-terraform-state-hemanthrajgandham"
    key="terraform.tfstate"
    encrypt=true
    use_lockfile=true
    region="us-east-1"
  
  }
}
