module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.29.0"

  # Cluster Configuration
  cluster_name                             = var.cluster_name
  cluster_version                          = var.cluster_version
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  create_iam_role                          = true
  enable_irsa                              = true

  # Cluster Addons
  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }

  # Network Configuration
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Cluster Logging Configuration
  cluster_enabled_log_types              = ["api", "audit", "authenticator"]
  cloudwatch_log_group_retention_in_days = 90

  # Managed Node Group Configuration
  eks_managed_node_group_defaults = { ami_type = var.ami_type }

  eks_managed_node_groups = {
    default = {
      name           = var.node_group_name
      instance_types = var.instance_types
      min_size       = var.node_count_min
      max_size       = var.node_count_max
      desired_size   = var.node_count
      disk_size      = var.disk_size
    }
  }

  iam_role_additional_policies = {
    eks_full_access = aws_iam_policy.eks_full_access.arn
  }

  # Tagging
  tags = merge(local.tags, { Name = "${var.name}-eks" })
}


module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}
