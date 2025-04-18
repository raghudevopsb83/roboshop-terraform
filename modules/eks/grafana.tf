resource "grafana_folder" "ec2-nodes" {
  title = "EC2-Nodes"
  uid   = "ec2-nodes"
}

resource "grafana_dashboard" "node-exporter" {
  folder = grafana_folder.ec2-nodes.uid
  config_json = jsonencode({
    "title" : "Node Exporter Full",
    "dashboard_id" : "12486"
  })
}

