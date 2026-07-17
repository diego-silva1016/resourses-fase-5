variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "state_bucket_name" {
  type    = string
  default = "solidarytech-terraform-state-fase-5"
}

variable "lock_table_name" {
  type    = string
  default = "solidarytech-terraform-locks"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "SolidaryTech"
  }
}
