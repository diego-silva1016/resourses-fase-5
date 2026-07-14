variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "solidarytech-vpc"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "SolidaryTech"
  }
}
