data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    region = var.vpc_state_region
    bucket = var.vpc_bucket
    key    = var.vpc_state_key
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    region = var.eks_state_region
    bucket = var.eks_bucket
    key    = var.eks_state_key
  }
}