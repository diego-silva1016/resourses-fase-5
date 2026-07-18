variable "release_name" {
  type    = string
  default = "ingress-nginx"
}

variable "namespace" {
  type    = string
  default = "ingress-nginx"
}

variable "chart_version" {
  type    = string
  default = "4.11.3"
}

variable "values" {
  type    = any
  default = {}
}

variable "tags" {
  type = map(string)
  default = {
    Project = "SolidaryTech"
  }
}
