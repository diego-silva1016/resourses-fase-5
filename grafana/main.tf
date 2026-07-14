module "grafana" {
  source = "git::https://github.com/diego-silva1016/terraform-blueprints-fase-5.git//grafana?ref=main"

  release_name    = var.release_name
  namespace       = var.namespace
  chart_version   = var.chart_version
  admin_password  = var.admin_password
  values          = var.values
  tags            = var.tags
}
