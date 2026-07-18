locals {
  otel_values = coalesce(var.values, {
    mode = var.mode
    image = {
      repository = "otel/opentelemetry-collector-contrib"
    }
    config = {
      receivers = {
        otlp = {
          protocols = {
            grpc = {}
            http = {}
          }
        }
      }
      exporters = {
        debug = {
          verbosity = "normal"
        }
        prometheusremotewrite = {
          endpoint = "http://prometheus-server.monitoring.svc.cluster.local:9090/api/v1/write"
        }
        loki = {
          endpoint = "http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push"
        }
        otlp = {
          endpoint = "https://otlp.nr-data.net:4317"
          headers = {
            "api-key" = coalesce(var.newrelic_license_key, "REPLACE_WITH_NEW_RELIC_LICENSE_KEY")
          }
        }
      }
      service = {
        pipelines = {
          traces = {
            receivers = ["otlp"]
            exporters = ["debug", "otlp"]
          }
          metrics = {
            receivers = ["otlp"]
            exporters = ["debug", "prometheusremotewrite"]
          }
          logs = {
            receivers = ["otlp"]
            exporters = ["debug", "loki"]
          }
        }
      }
    }
  })
}

module "otel_collector" {
  source = "git::https://github.com/diego-silva1016/terraform-blueprints-fase-5.git//otel-collector?ref=main"

  release_name  = var.release_name
  namespace     = var.namespace
  chart_version = var.chart_version
  mode          = var.mode
  values        = local.otel_values
  tags          = var.tags
}
