module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 21.0"
  name    = local.cluster_name
  kubernetes_version = var.kubernetes_version
  subnet_ids      = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true
  enable_irsa = true

  tags = {
    cluster = "demo"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_groups = {
    example = {
      ami_type               = "AL2_x86_64"
      instance_types         = ["t3.micro"]
      node_security_group_ids = [aws_security_group.all_worker_mgmt.id]


      min_size     = 2
      max_size     = 4
      desired_size = 2
    }
  }

}
