variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "repository_names" {
  type = list(string)
  default = [
    "ngo-service",
    "donation-service",
    "volunteer-service",
  ]
}

variable "tags" {
  type = map(string)
  default = {
    Project = "SolidaryTech"
  }
}
