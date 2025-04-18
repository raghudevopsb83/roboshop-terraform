resource "grafana_dashboard" "node-exporter" {
  folder = "/"
  config_json = jsonencode({
    "title" : "Node Exporter Full",
    "id" : "12486"
  })
}

