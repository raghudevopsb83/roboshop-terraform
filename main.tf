resource "aws_instance" "instance" {
  for_each = var.instances
  ami           = each.value[ami_id]
  instance_type = each.value[instance_type]
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name = each.key
  }
}


resource "aws_route53_record" "record" {
  for_each = var.instances
  zone_id = var.zone_id
  name    = "${each.key}-${var.env}"
  type    = "A"
  ttl     = 10
  records = [aws_instance.instance[each.key].private_ip]
}

# resource "null_resource" "catalogue" {
#   provisioner "remote-exec" {
#
#     connection {
#       type     = "ssh"
#       user     = "ec2-user"
#       password = "DevOps321"
#       host     = aws_instance.catalogue.private_ip
#     }
#
#     inline = [
#       "sudo pip3.11 install ansible",
#       "ansible-pull -i localhost, -U https://github.com/raghudevopsb83/roboshop-ansible roboshop.yml -e component_name=catalogue -e env-dev",
#     ]
#   }
# }