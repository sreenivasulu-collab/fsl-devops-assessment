terraform {
  backend "s3" {
    bucket         = "fsl-devops-tfstate-prod-us-west-1"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "fsl-devops-lock-prod"
    profile        = "fsl-devops-prod"
    encrypt        = true
  }
}
