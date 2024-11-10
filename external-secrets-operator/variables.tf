#-----------------------------------
# General variables
#-----------------------------------
variable "region" {
  description = "The AWS region to deploy resources."
  default     = "eu-south-1"
  type        = string
  validation {
    condition     = startswith(var.region, "eu-")
    error_message = "The region must be in Europe"
  }

}

variable "profile" {
  description = "The AWS profile to use."
  type        = string
  validation {
    condition     = length(var.profile) > 0
    error_message = "The profile must be a string, and cannot be empty."
  }
}

variable "kubectl_config_path" {
  description = "The path to the kubectl config file."
  type        = string
  default     = "~/.kube/config"
}

variable "kubectl_context" {
  description = "The kubectl context to use."
  type        = string
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = "eso-demo"
}
