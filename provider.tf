provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://vault-internal.rdevopsb83.online:8200"
  token   = var.vault_token
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "grafana" {
  url  = "https://grafana-dev.rdevopsb83.online"
  auth = "admin:prom-operator"
}


