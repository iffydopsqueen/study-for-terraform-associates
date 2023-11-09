terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias = "east"
  region = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "description"
}

variable "my_ami" {
  type = string
}

locals {
  project_name = "Dah_Queen"
}

resource "aws_instance" "app_server" {
  ami           = var.my_ami
  instance_type = var.instance_type

  tags = {
    Name = "${local.project_name}'s-Server"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-custom-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

// module "vpc" {
//   source = "terraform-aws-modules/vpc/aws"
//   providers = {
//     aws = aws.east
//   }

//   name = "my-custom-vpc"
//   cidr = "10.0.0.0/16"

//   azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
//   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
//   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

//   enable_nat_gateway = true
//   enable_vpn_gateway = true

//   tags = {
//     Terraform = "true"
//     Environment = "dev"
//   }
// }

output "instance_ip_addr" {
  value = aws_instance.app_server.public_ip
}