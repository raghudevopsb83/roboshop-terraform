resource "grafana_folder" "ec2-nodes" {
  title = "EC2-Nodes"
  uid   = "ec2-nodes"
}

resource "grafana_dashboard" "node-exporter" {
  folder = "/"
  config_json = jsonencode({
    "title" : "Node Exporter Full",
    "id" : "12486"
  })
}

