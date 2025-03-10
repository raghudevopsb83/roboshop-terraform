instances = {
  frontend = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    ansible_role     = "frontend-docker"
    root_volume_size = 30
  }
  catalogue = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    ansible_role     = "catalogue-docker"
    root_volume_size = 30
  }
  mongodb = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    root_volume_size = 20
  }
  redis = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    root_volume_size = 20
  }
  cart = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    ansible_role     = "cart-docker"
    root_volume_size = 30
  }
  user = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    ansible_role     = "user-docker"
    root_volume_size = 30
  }
  shipping = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    ansible_role     = "shipping-docker"
    root_volume_size = 30
  }
  mysql = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    root_volume_size = 20
  }
  rabbitmq = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    root_volume_size = 20
  }
  payment = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    ansible_role     = "payment-docker"
    root_volume_size = 30
  }
}

zone_id                = "Z01662431H5LL60AVTC0E"
vpc_security_group_ids = ["sg-0ea2a448676b70f53"]
env                    = "dev"

eks = {
  main = {
    subnets     = ["subnet-05554f3d4c8b12f4c", "subnet-028fcdd556176df9d"]
    eks_version = 1.32
  }
}
