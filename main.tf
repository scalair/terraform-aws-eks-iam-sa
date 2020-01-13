data "aws_region" "current" {}

data "external" "thumbprint" {
  program = ["${path.module}/script/init.sh", data.aws_region.current.name]
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
}

data "aws_iam_policy_document" "sts" {
  for_each = var.eks_cluster_policies

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = format("%s:sub", replace(data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url, "https://", ""))
      values   = ["system:serviceaccount:${each.key}"]
    }

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }
  }
}

data "aws_iam_policy_document" "eks" {
  for_each = var.eks_cluster_policies

  dynamic "statement" {
    for_each = each.value

    content {
      actions   = statement.value.actions
      resources = length(statement.value.resources) == 0 ? null : statement.value.resources
    }
  }
}

resource "aws_iam_policy" "eks" {
  for_each = var.eks_cluster_policies
  
  name        = replace(each.key, ":", "-")
  description = format("EKS policy attached to service account %s", each.key)

  policy = data.aws_iam_policy_document.eks[each.key].json
}

resource "aws_iam_role" "eks" {
  for_each = var.eks_cluster_policies
  
  name               = format("%s-%s", data.terraform_remote_state.eks.outputs.cluster_id, replace(each.key, ":", "-"))
  assume_role_policy = data.aws_iam_policy_document.sts[each.key].json
}

resource "aws_iam_role_policy_attachment" "eks" {
  for_each = var.eks_cluster_policies

  role       = aws_iam_role.eks[each.key].name
  policy_arn = aws_iam_policy.eks[each.key].arn
}