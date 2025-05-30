db_instances = {

  mongodb = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    root_volume_size = 20
    subnet_ref       = "db"
    port             = 27017
    app_cidr = {
      app-subnet-1 = "10.200.4.0/24"
      app-subnet-2 = "10.200.5.0/24"
    }
  }
  redis = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    root_volume_size = 20
    subnet_ref       = "db"
    port             = 6379
    app_cidr = {
      app-subnet-1 = "10.200.4.0/24"
      app-subnet-2 = "10.200.5.0/24"
    }
  }

  mysql = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    root_volume_size = 20
    subnet_ref       = "db"
    port             = 3306
    app_cidr = {
      app-subnet-1 = "10.200.4.0/24"
      app-subnet-2 = "10.200.5.0/24"
    }
  }
  rabbitmq = {
    ami_id           = "ami-09c813fb71547fc4f"
    instance_type    = "t3.small"
    root_volume_size = 20
    subnet_ref       = "db"
    port             = 5672
    app_cidr = {
      app-subnet-1 = "10.200.4.0/24"
      app-subnet-2 = "10.200.5.0/24"
    }
  }

}

zone_id                = "Z01662431H5LL60AVTC0E"
vpc_security_group_ids = ["sg-0ea2a448676b70f53"]
env                    = "dev"

eks = {
  main = {
    eks_version = 1.32
    node_groups = {
      main = {
        min_nodes      = 1
        max_nodes      = 10
        instance_types = ["t3.xlarge"]
        capacity_type  = "SPOT"
      }
    }

    addons = {
      #metrics-server = {}
      eks-pod-identity-agent = {}
    }

    access = {
      workstation = {
        role                    = "arn:aws:iam::633788536644:role/workstation-role"
        kubernetes_groups       = []
        policy_arn              = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope_type       = "cluster"
        access_scope_namespaces = []
      }
    }

  }
}

vpc = {
  main = {
    cidr = "10.200.0.0/16"
    subnets = {
      public-subnet-1 = {
        cidr  = "10.200.0.0/24"
        igw   = true
        ngw   = false
        zone  = "us-east-1a"
        group = "public"
      }
      public-subnet-2 = {
        cidr  = "10.200.1.0/24"
        igw   = true
        ngw   = false
        zone  = "us-east-1b"
        group = "public"
      }
      db-subnet-1 = {
        cidr  = "10.200.2.0/24"
        igw   = false
        ngw   = true
        zone  = "us-east-1a"
        group = "db"
      }
      db-subnet-2 = {
        cidr  = "10.200.3.0/24"
        igw   = false
        ngw   = true
        zone  = "us-east-1b"
        group = "db"
      }
      app-subnet-1 = {
        cidr  = "10.200.4.0/24"
        igw   = false
        ngw   = true
        zone  = "us-east-1a"
        group = "app"
      }
      app-subnet-2 = {
        cidr  = "10.200.5.0/24"
        igw   = false
        ngw   = true
        zone  = "us-east-1b"
        group = "app"
      }
    }
  }
}

default_vpc = {
  vpc_id        = "vpc-0d5347093a11ab560"
  vpc_cidr      = "172.31.0.0/16"
  routetable_id = "rtb-02807cbba5772ca48"
}

bastion_ssh_nodes = {
  workstation   = "172.31.34.25/32"
  github_runner = "172.31.2.181/32"
}

kms_arn = "arn:aws:kms:us-east-1:633788536644:key/ac0ffd8a-f1c7-4760-bad4-35d9fee335bb"


