variable "vpc_security_group_ids" {
  default = ["sg-0ea2a448676b70f53"]
}

variable "instances" {
  default = {
    frontend = {
      ami_id = "ami-09c813fb71547fc4f"
      instance_type = "t3.micro"
    }
    catalogue = {
      ami_id = "ami-09c813fb71547fc4f"
      instance_type = "t3.micro"
    }
    mongodb = {
      ami_id = "ami-09c813fb71547fc4f"
      instance_type = "t3.small"
    }
  }
}

variable "zone_id" {
  default = "Z01662431H5LL60AVTC0E"
}

variable "env" {
  default = "dev"
}
