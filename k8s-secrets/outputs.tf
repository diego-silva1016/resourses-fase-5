output "namespace" {
  value = kubernetes_namespace.solidarytech.metadata[0].name
}

output "ngo_service_secret_name" {
  value = kubernetes_secret.ngo_service.metadata[0].name
}

output "donation_service_secret_name" {
  value = kubernetes_secret.donation_service.metadata[0].name
}

output "donation_service_configmap_name" {
  value = kubernetes_config_map.donation_service.metadata[0].name
}

output "volunteer_service_secret_name" {
  value = kubernetes_secret.volunteer_service.metadata[0].name
}
