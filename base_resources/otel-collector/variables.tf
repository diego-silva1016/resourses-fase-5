variable "newrelic_license_key" {
  type      = string
  sensitive = true
  default   = null
}

variable "release_name" {
  type    = string
  default = "otel-collector"
}

variable "namespace" {
  type    = string
  default = "observability"
}

variable "chart_version" {
  type    = string
  default = "0.108.0"
}

variable "mode" {
  type    = string
  default = "deployment"
}

variable "values" {
  type    = any
  default = null
}

variable "tags" {
  type = map(string)
}
