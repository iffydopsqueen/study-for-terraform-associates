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

resource "aws_s3_bucket" "bucket" {
  bucket = "12345678910-some-bucket-name"
}

resource "aws_instance" "web_server" {
    ami           = "ami-0cd5f46e93e42a496"
    instance_type = "t2.micro"
    depends_on = [
        aws_s3_bucket.bucket
    ]
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}