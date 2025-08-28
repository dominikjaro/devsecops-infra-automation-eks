resource "aws_eks_access_entry" "admin_entry" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = aws_iam_role.external-admin.arn
  kubernetes_groups = ["system:masters"]
  username          = "admin"
}

resource "aws_eks_access_entry" "developer_entry" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = aws_iam_role.external-developer.arn
  kubernetes_groups = ["developers"]
  username          = "developer"
}
