resource "aws_instance" "instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = var.subnet_ids[0]

  root_block_device {
    volume_size = var.root_volume_size
  }

  tags = {
    Name    = var.name
    monitor = "true"
  }
}


resource "aws_security_group" "main" {
  name        = "${var.name}-sg"
  description = "${var.name}-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg"
  }
}


resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = "${var.name}-${var.env}"
  type    = "A"
  ttl     = 10
  records = [aws_instance.instance.private_ip]
}

resource "null_resource" "catalogue" {
  depends_on = [aws_route53_record.record]

  triggers = {
    instance_id_change = aws_instance.instance.id
  }

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = data.vault_generic_secret.ssh.data["username"]
      password = data.vault_generic_secret.ssh.data["password"]
      host     = aws_instance.instance.private_ip
    }

    inline = [
      "sudo pip3.11 install ansible hvac",
      "ansible-pull -i localhost, -U https://github.com/raghudevopsb83/roboshop-ansible roboshop.yml -e component_name=${var.ansible_role} -e env=${var.env} -e vault_token=${var.vault_token}",
    ]
  }
}


