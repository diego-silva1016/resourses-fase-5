module "grafana" {
  source = "../../terraform-blueprints/grafana"

  release_name    = var.release_name
  namespace       = var.namespace
  chart_version   = var.chart_version
  admin_password  = var.admin_password
  values          = var.values
  tags            = var.tags
}
