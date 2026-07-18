module "ecr" {
  source = "git::https://github.com/diego-silva1016/terraform-blueprints-fase-5.git//ecr?ref=main"

  repository_names = var.repository_names
  tags             = var.tags
}
