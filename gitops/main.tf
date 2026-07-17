# ---------------------------------------------------------------------------
# Stack independente: aplica os manifestos GitOps (ArgoCD Applications).
#
# Isolado do estado principal (resources/main.tf) de proposito, para nao
# concorrer com a criacao do EKS/ArgoCD no mesmo "plan". O provider
# alekc/kubectl exige host/token ja conhecidos (nao aceita valores
# "known after apply"), entao este stack le o cluster e o ArgoCD ja
# existentes via data sources, em vez de referenciar modules ainda nao
# aplicados.
#
# Uso:
#   cd resources        && terraform apply   (cria VPC/EKS/ArgoCD, etc.)
#   cd resources/gitops && terraform init && terraform apply
# ---------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket         = "solidarytech-terraform-state-fase-5"
    key            = "infrastructure/gitops.tfstate"
    region         = "us-east-1"
    dynamodb_table = "solidarytech-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
}

locals {
  gitops_raw_base_url = replace(var.gitops_repo_url, "https://github.com/", "https://raw.githubusercontent.com/")
}

data "http" "argocd_app_manifest" {
  for_each = toset(var.gitops_app_manifests)

  url = "${local.gitops_raw_base_url}/${var.gitops_repo_ref}/argocd-apps/${each.value}"
}

resource "kubectl_manifest" "argocd_app" {
  for_each = data.http.argocd_app_manifest

  yaml_body = each.value.response_body
}
