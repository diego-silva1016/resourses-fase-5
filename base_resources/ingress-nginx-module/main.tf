locals {
  ingress_nginx_defaults = {
    controller = {
      replicaCount = 2
      ingressClassResource = {
        name    = "nginx"
        enabled = true
        default = true
      }
      service = {
        type = "LoadBalancer"
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
        }
      }
    }
  }

  ingress_nginx_values = merge(local.ingress_nginx_defaults, var.values)
}

resource "helm_release" "ingress_nginx" {
  name             = var.release_name
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [yamlencode(local.ingress_nginx_values)]
}
