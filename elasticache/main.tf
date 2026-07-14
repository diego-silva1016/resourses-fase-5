module "elasticache" {
  source = "../../terraform-blueprints/elasticache"

  project_name       = var.project_name
  vpc_id             = var.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = var.private_subnet_ids
  cluster_id         = var.cluster_id
  tags               = var.tags
}
