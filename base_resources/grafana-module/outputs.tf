output "release_name" {
  value = module.grafana.release_name
}

output "namespace" {
  value = module.grafana.namespace
}

output "status" {
  value = module.grafana.status
}

output "admin_password" {
  value     = module.grafana.admin_password
  sensitive = true
}
