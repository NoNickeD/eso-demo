#-----------------------------------
# VPC Outputs
#-----------------------------------
output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "intra_subnets" {
  value = module.vpc.intra_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "gateway_id" {
  value = module.vpc.public_internet_gateway_route_id
}

#-----------------------------------
# EKS Outputs
#-----------------------------------
output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "new_kubecontext_addition_command" {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name} --profile ${var.profile} --alias ${var.new_kubeconfig_alias}"
}
