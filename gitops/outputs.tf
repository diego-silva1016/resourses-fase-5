output "argocd_applications" {
  value = [for k, v in kubectl_manifest.argocd_app : v.name]
}
