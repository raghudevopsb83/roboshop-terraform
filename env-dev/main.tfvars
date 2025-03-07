instances = {
    frontend = {
      ami_id        = "ami-09c813fb71547fc4f"
      instance_type = "t3.small"
      ansible_role  = "frontend-docker"
    }
    catalogue = {
      ami_id        = "ami-09c813fb71547fc4f"
      instance_type = "t3.small"
      ansible_role  = "catalogue-docker"
    }
    mongodb = {
      ami_id        = "ami-09c813fb71547fc4f"
      instance_type = "t3.small"
    }
    redis = {
      ami_id        = "ami-09c813fb71547fc4f"
      instance_type = "t3.small"
    }
    cart = {
      ami_id        = "ami-09c813fb71547fc4f"
      instance_type = "t3.small"
      ansible_role  = "cart-docker"
    }
    user = {
      ami_id        = "ami-09c813fb71547fc4f"
      instance_type = "t3.small"
      ansible_role  = "user-docker"
    }
    shipping = {
      ami_id        = "ami-09c813fb71547fc4f"
      instance_type = "t3.small"
      ansible_role  = "shipping-docker"
    }
    mysql = {
      ami_id        = "ami-09c813fb71547fc4f"
      instance_type = "t3.small"
    }
    rabbitmq = {
      ami_id        = "ami-09c813fb71547fc4f"
      instance_type = "t3.small"
    }
    payment = {
      ami_id        = "ami-09c813fb71547fc4f"
      instance_type = "t3.small"
      ansible_role  = "payment-docker"
    }
}

zone_id                = "Z01662431H5LL60AVTC0E"
vpc_security_group_ids = ["sg-0ea2a448676b70f53"]
env                    = "dev"

