variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "solidarytech-cluster"
}

variable "gitops_repo_url" {
  type    = string
  default = "https://github.com/diego-silva1016/postech-fase-5-gitops"
}

variable "gitops_repo_ref" {
  type    = string
  default = "main"
}

variable "gitops_app_manifests" {
  type = list(string)
  default = [
    "ngo-service-app.yaml",
    "donation-service-app.yaml",
    "volunteer-service-app.yaml",
  ]
}
