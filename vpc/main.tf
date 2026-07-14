module "vpc" {
  source = "git::https://github.com/diego-silva1016/terraform-blueprints-fase-5.git//vpc?ref=main"

  vpc_name = var.vpc_name
  tags     = var.tags
}
