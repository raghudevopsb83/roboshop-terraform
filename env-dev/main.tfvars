db_instances = {

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

}

zone_id                = "Z01662431H5LL60AVTC0E"
vpc_security_group_ids = ["sg-0ea2a448676b70f53"]
env                    = "dev"

eks = {
  main = {
    subnets     = ["subnet-05554f3d4c8b12f4c", "subnet-028fcdd556176df9d"]
    eks_version = 1.32
    node_groups = {
      main = {
        min_nodes      = 1
        max_nodes      = 10
        instance_types = ["t3.medium", "t3.large"]
      }
    }
  }
}
