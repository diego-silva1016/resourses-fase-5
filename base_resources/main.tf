terraform {
  backend "s3" {
    bucket         = "solidarytech-terraform-state-fase-5"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "solidarytech-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# ---------------------------------------------------------------------------
# Variables
# ---------------------------------------------------------------------------

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "solidarytech"
}

variable "vpc_name" {
  type    = string
  default = "solidarytech-vpc"
}

variable "cluster_name" {
  type    = string
  default = "solidarytech-cluster"
}

variable "lab_role_name" {
  type    = string
  default = "LabRole"
}

variable "elasticache_cluster_id" {
  type    = string
  default = "solidarytech-cache"
}

variable "newrelic_license_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "enable_observability" {
  type    = bool
  default = true
}

variable "enable_gitops" {
  type    = bool
  default = true
}

variable "tags" {
  type = map(string)
  default = {
    Project = "SolidaryTech"
  }
}

# ---------------------------------------------------------------------------
# Providers
# ---------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

data "aws_iam_role" "lab_role" {
  name = var.lab_role_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
# ---------------------------------------------------------------------------
# Infrastructure modules (resources/<subpasta>)
# ---------------------------------------------------------------------------

module "vpc" {
  source = "./vpc"

  vpc_name = var.vpc_name
  tags     = var.tags
}

module "ecr" {
  source = "./ecr"

  tags = var.tags
}

module "sqs" {
  source = "./solidary-donations-sqs"

  tags = var.tags
}

module "dynamodb" {
  source = "./volunteer-dynamo-db"

  tags = var.tags
}

module "ngo_db" {
  source = "./ngo-db"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = module.vpc.vpc_cidr_block
  private_subnet_ids = module.vpc.private_subnet_ids_list
  tags               = var.tags

  depends_on = [module.vpc]
}

module "donation_db" {
  source = "./donation-db"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = module.vpc.vpc_cidr_block
  private_subnet_ids = module.vpc.private_subnet_ids_list
  tags               = var.tags

  depends_on = [module.vpc]
}

module "elasticache" {
  source = "./elasticache"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = module.vpc.vpc_cidr_block
  private_subnet_ids = module.vpc.private_subnet_ids_list
  cluster_id         = var.elasticache_cluster_id
  tags               = var.tags

  depends_on = [module.vpc]
}

module "eks" {
  source = "./eks"

  cluster_name     = var.cluster_name
  cluster_role_arn = data.aws_iam_role.lab_role.arn
  node_role_arn    = data.aws_iam_role.lab_role.arn
  subnet_ids       = module.vpc.private_subnet_ids_list
  tags             = var.tags

  depends_on = [module.vpc]
}

module "argocd" {
  count  = var.enable_gitops ? 1 : 0
  source = "./argocd"

  tags = var.tags

  depends_on = [module.eks]
}

# A aplicacao dos manifestos GitOps (ArgoCD Applications) fica isolada em
# resources/gitops/, que e um stack Terraform independente (estado proprio),
# aplicado separadamente depois que o EKS e o ArgoCD (acima) ja existirem.
# Ver resources/gitops/main.tf.
#
# Os Secrets Kubernetes (ex.: DATABASE_URL do ngo-service) ficam isolados em
# resources/k8s-secrets/, aplicados apos EKS e RDS existirem.
# Ver resources/k8s-secrets/main.tf.

module "prometheus" {
  count  = var.enable_observability ? 1 : 0
  source = "./prometheus-module"

  tags = var.tags

  depends_on = [module.eks]
}

module "grafana" {
  count  = var.enable_observability ? 1 : 0
  source = "./grafana-module"

  tags = var.tags

  depends_on = [module.eks]
}

module "loki" {
  count  = var.enable_observability ? 1 : 0
  source = "./loki-module"

  tags = var.tags

  depends_on = [module.eks]
}

module "otel_collector" {
  count  = var.enable_observability ? 1 : 0
  source = "./otel-collector"

  newrelic_license_key = var.newrelic_license_key
  tags                 = var.tags

  depends_on = [module.eks, module.prometheus, module.loki]
}

module "newrelic" {
  count  = var.enable_observability && var.newrelic_license_key != null ? 1 : 0
  source = "./newrelic"

  cluster_name         = var.cluster_name
  newrelic_license_key = var.newrelic_license_key
  tags                 = var.tags

  depends_on = [module.eks]
}

# ---------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "sqs_queue_url" {
  value = module.sqs.queue_url
}

output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}

output "ngo_db_endpoint" {
  value = module.ngo_db.db_instance_endpoint
}

output "donation_db_endpoint" {
  value = module.donation_db.db_instance_endpoint
}

output "elasticache_address" {
  value = module.elasticache.cache_cluster_address
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "argocd_namespace" {
  value = var.enable_gitops ? module.argocd[0].namespace : null
}

output "grafana_admin_password" {
  value     = var.enable_observability ? module.grafana[0].admin_password : null
  sensitive = true
}

output "prometheus_namespace" {
  value = var.enable_observability ? module.prometheus[0].namespace : null
}

output "loki_namespace" {
  value = var.enable_observability ? module.loki[0].namespace : null
}

output "otel_collector_namespace" {
  value = var.enable_observability ? module.otel_collector[0].namespace : null
}

output "newrelic_namespace" {
  value = length(module.newrelic) > 0 ? "newrelic" : null
}
