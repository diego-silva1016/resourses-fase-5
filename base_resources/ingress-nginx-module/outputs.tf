output "release_name" {
  value = helm_release.ingress_nginx.name
}

output "namespace" {
  value = helm_release.ingress_nginx.namespace
}

output "status" {
  value = helm_release.ingress_nginx.status
}

output "service_name" {
  value = "${helm_release.ingress_nginx.name}-controller"
}
