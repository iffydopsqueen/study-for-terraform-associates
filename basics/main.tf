terraform {
  #Terraform Cloud 
  cloud {
    organization = "terraform-associate-23"

    workspaces {
      name = "terraform-basics"
    }
  }

  # Providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

locals {
  project_name = "Dah_Queen"
}