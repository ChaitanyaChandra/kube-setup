locals {
  env         = trimprefix("${var.TFC_WORKSPACE_NAME}", "chaitu-eks-")
  Environment = local.env == "dr" || local.env == "prod" ? "prod" : "nonpord"
  region      = local.env == "dr" || local.env == "prod" ? "us-west-2" : "us-east-1"
  tags = {
    "Environment"  = local.Environment
    "region"       = local.region
    "Service"      = "chaitu"
    "SupportGroup" = "Managed Services L2"
  }
  env_tag = {
    "appenv" = local.env
  }
}

variable "TFC_WORKSPACE_NAME" {
  sensitive   = true
  type        = string
  description = "WORKSPACE NAME imported from tfe"
}

variable "cluster_name" {
  type    = string
  default = "eks"
}

variable "k8s_version" {
  type    = string
  default = "1.21"
}

variable "release_version" {
  type    = string
  default = "1.21.5-20220309"
}

variable "min_node_count" {
  type    = number
  default = 2
}

variable "max_node_count" {
  type    = number
  default = 3
}

variable "machine_type" {
  type    = string
  default = "t3.xlarge"
}

variable "TFC_AWS_SECRET_ACCESS_KEY" {
  sensitive = true
}