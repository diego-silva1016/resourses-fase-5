variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "solidarytech-cluster"
}

variable "namespace" {
  type    = string
  default = "solidarytech"
}

variable "ngo_db_identifier" {
  type    = string
  default = "ngo-db"
}

variable "ngo_secret_name" {
  type    = string
  default = "ngo-service-secrets"
}
