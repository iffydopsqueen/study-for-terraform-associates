terraform {
  # Providers
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

locals {
  project_name = "Dah_Queen"
}

variable "instance_type" {
  type        = string
  description = "The size of the instance"
  validation {
    condition     = can(regex("^t2.",var.instance_type))
    error_message = "The instance must be a t2 type EC2 instance"
  }
}

variable "my_ami" {
  type = string
  description = "The Amazon Image of the instance"
  validation {
    condition     = can(regex("^ami-",var.my_ami))
    error_message = "Your AMI is not properly formatted"
  }
}

resource "aws_instance" "app_server" {
  ami           = var.my_ami
  instance_type = var.instance_type

  tags = {
    Name = "${local.project_name}'s-Server"
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}
