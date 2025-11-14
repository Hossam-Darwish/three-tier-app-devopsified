module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_private_access = true
  endpoint_public_access  = true


  node_security_group_additional_rules = {
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  eks_managed_node_groups = {
  example = {
    instance_types = ["t3.medium"]
    ami_type       = "AL2_x86_64"

    min_size     = 1
    max_size     = 2
    desired_size = 1

    additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }
}


  enable_cluster_creator_admin_permissions = true
  enable_irsa = true

  tags = {
    cluster = "demo"
  }
}