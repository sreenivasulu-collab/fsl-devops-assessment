terraform {
  backend "s3" {
    bucket         = "fsl-devops-tfstate-devel-us-east-1"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "fsl-devops-lock-devel"
    profile        = "fsl-devops-devel"
    encrypt        = true
  }
}
