variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "state_bucket_name" {
  type    = string
  default = "solidarytech-terraform-state-fase-5"
}

variable "release_name" {
  type    = string
  default = "argocd"
}

variable "namespace" {
  type    = string
  default = "argocd"
}

variable "chart_version" {
  type    = string
  default = "7.7.11"
}

variable "values" {
  type    = map(any)
  default = {}
}

variable "tags" {
  type = map(string)
  default = {
    Project = "SolidaryTech"
  }
}
