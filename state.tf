terraform {
  backend "s3" {}
  required_providers {
    grafana = {
      source  = "grafana/grafana"
    }
  }
}


