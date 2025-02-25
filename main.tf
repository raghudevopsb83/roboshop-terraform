resource "aws_instance" "instance" {
  count = length(var.instances)
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name = var.instances[count.index]
  }
}


# resource "aws_route53_record" "catalogue" {
#   zone_id = "Z01662431H5LL60AVTC0E"
#   name    = "catalogue-dev"
#   type    = "A"
#   ttl     = 10
#   records = [aws_instance.catalogue.private_ip]
# }
#
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