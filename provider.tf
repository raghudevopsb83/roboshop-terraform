provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://vault-internal.rdevopsb83.online:8200"
  token   = var.vault_token
}



