#  DevSecOps AWS Infrastructure Automation

## Branch: main

Infrastructure-as-Code (IaC) repository provisioning a secure, VPC and AWS EKS cluster.
We are using public modules to apply the resources. To simplyfy the setup, don't have sub-modules.
We apply the resources via a pipeline using GitLab CI - so the variable values are defined in GitLab.

This project is built iteratively across feature branches to demonstrate my DevSecOps bootcamp learning. It was forked from the original course repo, howver my branches have the suffix `-dom`

* `feature/1-rbac-update-dom`
* `feature/2-iac-pipeline-dom`
* `feature/3-eks-blueprints-dom`
* `feature/4-argocd-gitops-dom`
* `feature/5-policy-as-code-dom`

---

## Branch: feature/1-rbac-update-dom

We are adding Kubernetes provider and additional K8s and AWS resources. e.g.

* RBAC roles and bindings
* Mapping AWS roles to K8s
* IAM roles
* The users are created manually in AWS e.g. k8s-admin

## Branch: feature/2-iac-pipeline-dom

* Adding the pipeline for IaC deployment and automation.
* We initialize terraform and build-plan and apply. There is a cleanup step that can be run manually.
* The terraform plan file is saved as an artifact, so it can be applied later.
* We are using a terraform image, however had to install aws cli on it for authentication.
* In AWS under Access Management I created an Identity Provider for GitLab OIDC, then a Web Identity role, which has the Trust relationship with the    Identity Provider, allowing GitLab to assume the role and interact with AWS resources securely. For more info see -> [14_secure_iac_pipeline_for_eks_provisioning](https://gitlab.com/dominikjaro_devsecops_bootcamp/notes_overview/-/blob/aa97d58f89f23e419c84204eb2d4e33645936bc7/chapters_notes/14_secure_iac_pipeline_for_eks_provisioning.md)

## Branch: feature/3-eks-blueprints-dom

Helm provider and add_ons....