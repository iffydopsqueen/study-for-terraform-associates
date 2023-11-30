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
  alias = "west"
}

provider "aws" {
  region = "us-east-2"
  alias = "east"
}

data "aws_ami" "west-amazon-linux-2" {
	provider = aws.west

 	most_recent = true
	owners = ["amazon"]

	filter {
		name   = "owner-alias"
		values = ["amazon"]
	}
	filter {
		name   = "name"
		values = ["amzn2-ami-hvm*"]
	}
}

data "aws_ami" "east-amazon-linux-2" {
	provider = aws.east

 	most_recent = true
	owners = ["amazon"]
    
	filter {
		name   = "owner-alias"
		values = ["amazon"]
	}
	filter {
		name   = "name"
		values = ["amzn2-ami-hvm*"]
	}
}

resource "aws_instance" "west_web_server" {
    ami           = data.aws_ami.west-amazon-linux-2.id
    instance_type = "t2.micro"
    provider      = aws.west

    tags = {
        Name = "West-Server"
    }
}

resource "aws_instance" "east_web_server" {
    ami           = data.aws_ami.east-amazon-linux-2.id
    instance_type = "t2.micro"
    provider      = aws.east

    tags = {
        Name = "East-Server"
    }
}

output "west_public_ip" {
  value = aws_instance.west_web_server.public_ip
}

output "east_public_ip" {
  value = aws_instance.east_web_server.public_ip
}