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

output "instance_ip_addr" {
  value = aws_instance.app_server.public_ip
}