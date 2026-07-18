module "eks" {
  source = "git::https://github.com/diego-silva1016/terraform-blueprints-fase-5.git//eks?ref=main"

  cluster_name     = var.cluster_name
  cluster_role_arn = var.cluster_role_arn
  node_role_arn    = var.node_role_arn
  subnet_ids       = var.subnet_ids
  tags             = var.tags
  desired_size     = var.desired_size
  max_size         = var.max_size
}
