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

Adding the pipeline for IaC deployment and automation.
We initialize terraform and build-plan and apply. There is a cleanup step that can be run manually.
We are using a terraform image, however had to install aws cli on it.