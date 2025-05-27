output "subnets" {
#   value = [for k, v in var.subnets : aws_subnet.main[v.group].id]
  value = {for k,v in var.subnets : v.group => [for k, v in var.subnets : aws_subnet.main[k].id]}
}


