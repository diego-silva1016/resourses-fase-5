module "vpc" {
  source = "../../terraform-blueprints/vpc"

  vpc_name = var.vpc_name
  tags     = var.tags
}
