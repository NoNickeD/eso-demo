terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.30"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
}

# AWS Provider Configuration
provider "aws" {
  region  = var.region
  profile = var.profile
}

# Kubernetes Provider Configuration for EKS Cluster
provider "kubernetes" {
  config_path    = var.kubectl_config_path
  config_context = var.kubectl_context
}

# Helm Provider Configuration for managing Kubernetes resources with Helm
provider "helm" {
  kubernetes {
    config_path    = var.kubectl_config_path
    config_context = var.kubectl_context
  }
}

# TLS Provider Configuration (for certificates, if needed in other parts of the configuration)
provider "tls" {}
