module "ecr" {
  source = "../../terraform-blueprints/ecr"

  repository_names = var.repository_names
  tags             = var.tags
}
