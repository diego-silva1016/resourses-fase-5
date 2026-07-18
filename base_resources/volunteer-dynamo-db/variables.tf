variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "table_name" {
  type    = string
  default = "SolidaryTechVolunteers"
}

variable "hash_key" {
  type    = string
  default = "volunteer_id"
}

variable "hash_key_type" {
  type    = string
  default = "S"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "SolidaryTech"
  }
}
