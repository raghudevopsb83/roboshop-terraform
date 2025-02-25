variable "ami_id" {
  default = "ami-09c813fb71547fc4f"
}

variable "instance_type" {
  default = "t3.small"
}

variable "vpc_security_group_ids" {
  default = ["sg-0ea2a448676b70f53"]
}

variable "instances" {
  default = {
    catalogue = null
    mongodb = null
    frontend = null
  }
}

variable "zone_id" {
  default = "Z01662431H5LL60AVTC0E"
}

variable "env" {
  default = "dev"
}
