locals {
  loki_defaults = {
    deploymentMode = "SingleBinary"
    loki = {
      auth_enabled = false
      commonConfig = {
        replication_factor = 1
      }
      schemaConfig = {
        configs = [{
          from         = "2024-01-01"
          store        = "tsdb"
          object_store = "filesystem"
          schema       = "v13"
          index = {
            prefix = "loki_index_"
            period = "24h"
          }
        }]
      }
      storage = {
        type = "filesystem"
        bucketNames = {
          chunks = "chunks"
          ruler  = "ruler"
          admin  = "admin"
        }
      }
    }
    singleBinary = {
      replicas = 1
      persistence = {
        enabled = false
      }
      extraVolumes = [{
        name     = "storage"
        emptyDir = {}
      }]
      extraVolumeMounts = [{
        name      = "storage"
        mountPath = "/var/loki"
      }]
    }
    backend = {
      replicas = 0
    }
    read = {
      replicas = 0
    }
    write = {
      replicas = 0
    }
    ingester = {
      replicas = 0
    }
    querier = {
      replicas = 0
    }
    queryFrontend = {
      replicas = 0
    }
    queryScheduler = {
      replicas = 0
    }
    distributor = {
      replicas = 0
    }
    compactor = {
      replicas = 0
    }
    indexGateway = {
      replicas = 0
    }
    bloomCompactor = {
      replicas = 0
    }
    bloomGateway = {
      replicas = 0
    }
    chunksCache = {
      enabled = false
    }
    resultsCache = {
      enabled = false
    }
    monitoring = {
      selfMonitoring = {
        enabled = false
      }
      serviceMonitor = {
        enabled = false
      }
    }
  }

  loki_values = merge(local.loki_defaults, var.values)
}

module "loki" {
  source = "git::https://github.com/diego-silva1016/terraform-blueprints-fase-5.git//loki?ref=main"

  release_name  = var.release_name
  namespace     = var.namespace
  chart_version = var.chart_version
  values        = local.loki_values
  tags          = var.tags
}
