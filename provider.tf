terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
#  cloud { # using git based source.. not cli
#    organization = "chaitu"
#
#    workspaces {
#      name = "chaitu-eks-"
#    }
#  }
}

provider "aws" {
  region     = local.region
  # access_key = "" # imported from tfe
  # secret_key = ""
}
