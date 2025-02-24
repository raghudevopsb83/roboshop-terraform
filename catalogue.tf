resource "aws_instance" "catalogue" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-0ea2a448676b70f53"]

  tags = {
    Name = "catalogue"
  }

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = self.public_ip
    }

    inline = [
      "sudo pip3.11 install ansible",
      "ansible-pull -i localhost, -U https://github.com/raghudevopsb83/roboshop-shell roboshop.yml -e component_name=catalogue -e env=dev",
    ]
  }

}


resource "aws_route53_record" "catalogue" {
  zone_id = "Z01662431H5LL60AVTC0E"
  name    = "catalogue-dev"
  type    = "A"
  ttl     = 10
  records = [aws_instance.catalogue.private_ip]
}

