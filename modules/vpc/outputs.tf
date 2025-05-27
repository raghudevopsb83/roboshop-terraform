output "subnets" {
  value = [for k, v in var.subnets : aws_subnet.main[k.group].id]
}

