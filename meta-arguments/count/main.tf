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
    count         = 2

    ami           = "ami-0cd5f46e93e42a496"
    instance_type = "t2.micro"

    tags = {
        # if you want your server count to start from 1
		Name = "Server-${count.index + 1}"
	}
}

output "public_ip" {
  value = aws_instance.web_server[*].public_ip
}