variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "queue_name" {
  type    = string
  default = "solidary-donations"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "SolidaryTech"
  }
}
