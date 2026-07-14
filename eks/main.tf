module "eks" {
  source = "../../terraform-blueprints/eks"

  cluster_name     = var.cluster_name
  cluster_role_arn = var.cluster_role_arn
  node_role_arn    = var.node_role_arn
  subnet_ids       = var.subnet_ids
  tags             = var.tags
}
