variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "state_bucket_name" {
  type    = string
  default = "solidarytech-terraform-state"
}

variable "release_name" {
  type    = string
  default = "prometheus"
}

variable "namespace" {
  type    = string
  default = "monitoring"
}

variable "chart_version" {
  type    = string
  default = "25.27.0"
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
