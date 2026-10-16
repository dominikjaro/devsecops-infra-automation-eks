provider "aws" {
  region = var.aws_region
}
# VPC for Cluster
data "aws_availability_zones" "azs" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = var.name
  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = var.tags
}

# EKS Cluster

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.1"

  name                                     = var.name
  kubernetes_version                       = var.k8s_version
  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  create_security_group      = false
  create_node_security_group = false

  addons = {
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
    coredns = {}
  }

  eks_managed_node_groups = {
    initial = {
      instance_types = ["t3.micro"]
      min_size       = 2
      max_size       = 20
      desired_size   = 4
    }
  }

  tags = var.tags
}
resource "aws_eks_access_entry" "admin_entry" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = aws_iam_role.external-admin.arn
  type              = "STANDARD"
  kubernetes_groups = ["restricted-admins"]
}

resource "aws_eks_access_entry" "dev_entry" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.external-developer.arn
  type          = "STANDARD"
}
resource "aws_eks_access_policy_association" "dev_policy" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.dev_entry.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

  access_scope {
    namespaces = ["online-boutique"]
    type       = "namespace"
  }
}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_aws_load_balancer_controller = true
  enable_metrics_server               = true
  enable_cluster_autoscaler           = true
  cluster_autoscaler = {
    set = [
      {
        name  = "extraArgs.scale-down-unneeded-time"
        value = "1m"
      },
      {
        name  = "extraArgs.skip-nodes-with-local-storage"
        value = false
      },
      {
        name  = "extraArgs.skip-nodes-with-system-pods"
        value = false
      }
    ]
  }

  enable_argocd        = true
  enable_argo_rollouts = true

  argocd = {
    values = [
      yamlencode({
        server = {
          service = {
            annotations = {
              "service.beta.kubernetes.io/aws-load-balancer-name"            = "argocd"
              "service.beta.kubernetes.io/aws-load-balancer-type"            = "external"
              "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
              "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internet-facing"
            },
            type = "LoadBalancer"
          }
        }
      })
    ]
  }

}
