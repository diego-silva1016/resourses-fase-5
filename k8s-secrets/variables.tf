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

variable "donation_db_identifier" {
  type    = string
  default = "donation-db"
}

variable "donation_secret_name" {
  type    = string
  default = "donation-service-secrets"
}

variable "donation_configmap_name" {
  type    = string
  default = "donation-service-config"
}

variable "donation_service_port" {
  type    = string
  default = "8082"
}

variable "sqs_queue_name" {
  type    = string
  default = "solidary-donations"
}

variable "aws_access_key_id" {
  type      = string
  sensitive = true
}

variable "aws_secret_access_key" {
  type      = string
  sensitive = true
}

variable "aws_session_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "volunteer_secret_name" {
  type    = string
  default = "volunteer-service-secrets"
}
