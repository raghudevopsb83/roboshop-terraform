output "subnets" {
#   value = [for k, v in var.subnets : aws_subnet.main[v.group].id]
  value = [for k,v in aws_subnet.main : v.id ]
}


