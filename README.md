#  DevSecOps AWS Infrastructure Automation

Infrastructure-as-Code (IaC) repository provisioning a secure, VPC and AWS EKS cluster.
We are using public modules to apply the resources. To simplyfy the setup, don't have sub-modules.
We apply the resources via a pipeline using GitLab CI - so the variable values are defined in GitLab.

## Repository Structure

This project is built iteratively across feature branches to demonstrate my DevSecOps bootcamp learning. It was forked from the original course repo, howver my branches have the suffix `-dom`

* `feature/1-rbac-update-dom`
* `feature/2-iac-pipeline-dom`
* `feature/3-eks-blueprints-dom`
* `feature/4-argocd-gitops-dom`
* `feature/5-policy-as-code-dom`