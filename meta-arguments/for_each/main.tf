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
    for_each = {
      nano = "t2.nano"
      micro =  "t2.micro"
      small =  "t2.small"
    }

    ami           = "ami-0cd5f46e93e42a496"
    instance_type = each.value

    tags = {
      Name = "${each.key}-type-server"
	}
}

output "public_ip" {
  value = values(aws_instance.web_server)[*].public_ip
}