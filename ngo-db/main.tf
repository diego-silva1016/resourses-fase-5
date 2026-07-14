module "ngo_db" {
  source = "git::https://github.com/diego-silva1016/terraform-blueprints-fase-5.git//rds?ref=main"

  project_name       = var.project_name
  vpc_id             = var.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = var.private_subnet_ids
  db_identifier      = "ngo-db"
  db_name            = "ngo_db"
  db_username        = "ngo_admin"
  tags               = var.tags
}
