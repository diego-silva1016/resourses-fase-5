module "ngo_db" {
  source = "../../terraform-blueprints/rds"

  project_name       = var.project_name
  vpc_id             = var.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = var.private_subnet_ids
  db_identifier      = "ngo-db"
  db_name            = "ngo_db"
  db_username        = "ngo_admin"
  tags               = var.tags
}
