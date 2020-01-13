output "aws_iam_openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "data_aws_iam_policy_document_sts" {
  value = data.aws_iam_policy_document.sts
}

output "data_aws_iam_policy_document_eks" {
  value = data.aws_iam_policy_document.eks
}

output "aws_iam_role_eks_arn" {
  value = aws_iam_role.eks
}