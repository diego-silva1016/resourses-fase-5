output "namespace" {
  value = kubernetes_namespace.solidarytech.metadata[0].name
}

output "ngo_service_secret_name" {
  value = kubernetes_secret.ngo_service.metadata[0].name
}
