module "prometheus" {
  source = "git::https://github.com/diego-silva1016/terraform-blueprints-fase-5.git//prometheus?ref=main"

  release_name  = var.release_name
  namespace     = var.namespace
  chart_version = var.chart_version
  values        = var.values
  tags          = var.tags
}
