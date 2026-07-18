locals {
  prometheus_defaults = {
    server = {
      persistentVolume = {
        enabled = false
      }
    }
    alertmanager = {
      persistence = {
        enabled = false
      }
    }
  }

  prometheus_values = merge(local.prometheus_defaults, var.values)
}

module "prometheus" {
  source = "git::https://github.com/diego-silva1016/terraform-blueprints-fase-5.git//prometheus?ref=main"

  release_name  = var.release_name
  namespace     = var.namespace
  chart_version = var.chart_version
  values        = local.prometheus_values
  tags          = var.tags
}
