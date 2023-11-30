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

resource "aws_instance" "web_server" {
    ami           = "ami-0cd5f46e93e42a496"
    instance_type = "t2.micro"

    tags = {
        Name = "Web-Server"
    }

    lifecycle {
        #create_before_destroy = true
        prevent_destroy = true
        #ignore_changes = true
    }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}