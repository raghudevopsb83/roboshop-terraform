resource "aws_instance" "catalogue" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-0ea2a448676b70f53"]

  tags = {
    Name = "catalogue"
  }
}


resource "aws_route53_record" "catalogue" {
  zone_id = "Z01662431H5LL60AVTC0E"
  name    = "frontend-dev"
  type    = "A"
  ttl     = 10
  records = [aws_instance.catalogue.private_ip]
}

