resource "aws_instance" "mongodb" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-0ea2a448676b70f53"]

  tags = {
    Name = "mongodb"
  }



}


resource "aws_route53_record" "mongodb" {
  zone_id = "Z01662431H5LL60AVTC0E"
  name    = "mongodb-dev"
  type    = "A"
  ttl     = 10
  records = [aws_instance.mongodb.private_ip]
}

resource "null_resource" "mongodb" {
    provisioner "remote-exec" {

      connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = aws_instance.mongodb.private_ip
      }

      inline = [
        "sudo pip3.11 install ansible",
        "ansible-pull -i localhost, -U https://github.com/raghudevopsb83/roboshop-ansible roboshop.yml -e component_name=mongodb -e env-dev",
      ]
    }
}


