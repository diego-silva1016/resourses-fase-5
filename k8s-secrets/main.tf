# ---------------------------------------------------------------------------
# Stack independente: cria Secrets e ConfigMaps Kubernetes com credenciais do
# RDS e demais parametros de configuracao (ex.: URL da fila SQS).
#
# Isolado do estado principal (resources/main.tf) de proposito, para nao
# concorrer com a criacao do EKS/RDS no mesmo "plan". Le o cluster, o RDS,
# o Secrets Manager e a fila SQS ja existentes via data sources.
#
# Uso:
#   cd resources           && terraform apply   (cria VPC/EKS/RDS/SQS, etc.)
#   cd resources/k8s-secrets && terraform init && terraform apply
# ---------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket         = "solidarytech-terraform-state-fase-5"
    key            = "infrastructure/k8s-secrets.tfstate"
    region         = "us-east-1"
    dynamodb_table = "solidarytech-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
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

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

data "aws_db_instance" "ngo_db" {
  db_instance_identifier = var.ngo_db_identifier
}

data "aws_secretsmanager_secret_version" "ngo_db_password" {
  secret_id = "rds-postgres-password-${var.ngo_db_identifier}"
}

data "aws_db_instance" "donation_db" {
  db_instance_identifier = var.donation_db_identifier
}

data "aws_secretsmanager_secret_version" "donation_db_password" {
  secret_id = "rds-postgres-password-${var.donation_db_identifier}"
}

data "aws_sqs_queue" "donations" {
  name = var.sqs_queue_name
}

resource "kubernetes_namespace" "solidarytech" {
  metadata {
    name = var.namespace
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations, metadata[0].labels]
  }
}

resource "kubernetes_secret" "ngo_service" {
  metadata {
    name      = var.ngo_secret_name
    namespace = var.namespace
  }

  data = {
    DATABASE_URL = "postgresql://${data.aws_db_instance.ngo_db.master_username}:${urlencode(data.aws_secretsmanager_secret_version.ngo_db_password.secret_string)}@${data.aws_db_instance.ngo_db.address}:${data.aws_db_instance.ngo_db.port}/${data.aws_db_instance.ngo_db.db_name}"
  }

  type = "Opaque"
}

resource "kubernetes_secret" "donation_service" {
  metadata {
    name      = var.donation_secret_name
    namespace = var.namespace
  }

  data = {
    DATABASE_URL = "postgresql://${data.aws_db_instance.donation_db.master_username}:${urlencode(data.aws_secretsmanager_secret_version.donation_db_password.secret_string)}@${data.aws_db_instance.donation_db.address}:${data.aws_db_instance.donation_db.port}/${data.aws_db_instance.donation_db.db_name}"
  }

  type = "Opaque"
}

resource "kubernetes_config_map" "donation_service" {
  metadata {
    name      = var.donation_configmap_name
    namespace = var.namespace
    labels = {
      app = "donation-service"
    }
  }

  data = {
    PORT        = var.donation_service_port
    AWS_REGION  = var.aws_region
    AWS_SQS_URL = data.aws_sqs_queue.donations.url
  }
}

resource "kubernetes_secret" "volunteer_service" {
  metadata {
    name      = var.volunteer_secret_name
    namespace = var.namespace
  }

  data = {
    AWS_ACCESS_KEY_ID     = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
    AWS_SESSION_TOKEN     = var.aws_session_token
  }

  type = "Opaque"
}
