provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

resource "kubernetes_namespace" "online-boutique" {
  metadata {
    name = "online-boutique"
  }
}

resource "kubernetes_cluster_role" "restricted_admin" {
  metadata {
    name = "restricted-admin"
  }

  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "restricted_admin_binding" {
  metadata {
    name = "restricted-admin-binding"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "restricted-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = "restricted-admins"
    api_group = "rbac.authorization.k8s.io"
  }
}
