module "newrelic" {
  source = "../../terraform-blueprints/newrelic"

  release_name  = var.release_name
  namespace     = var.namespace
  chart_version = var.chart_version
  license_key   = var.newrelic_license_key
  cluster_name  = var.cluster_name
  low_data_mode   = var.low_data_mode
  values        = var.values
  tags          = var.tags
}
