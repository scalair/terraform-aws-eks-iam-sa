####################
# VPC remote state #
####################
variable "vpc_bucket" {
  description = "Name of the bucket where vpc state is stored"
  type        = string
}

variable "vpc_state_key" {
  description = "Key where the state file of the VPC is stored"
  type        = string
}

variable "vpc_state_region" {
  description = "Region where the state file of the VPC is stored"
  type        = string
}

####################
# EKS remote state #
####################
variable "eks_bucket" {
  description = "Name of the bucket where EKS state is stored"
  type        = string
}

variable "eks_state_key" {
  description = "Key where the state file of the EKS is stored"
  type        = string
}

variable "eks_state_region" {
  description = "Region where the state file of the EKS is stored"
  type        = string
}

#############
# IAM roles #
#############

variable "eks_cluster_policies" {
  description = "List of policies to create that will be associated to roles linked to service accounts. The map keys represent service accounts: they must be to the form namespace:name"
  type = map(list(object({
    actions   = list(string)
    resources = list(string)
  })))
  default = {}
}