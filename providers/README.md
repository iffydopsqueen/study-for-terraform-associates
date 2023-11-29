# Terraform Providers

## Terraform Providers

A Terraform provider is a plugin that allows Terraform to interact with and manage resources within a specific infrastructure platform or service.

Providers are a crucial component of Terraform. Each provider is responsible for translating Terraform configurations into API calls or other actions that manipulate resources on the target platform.

- Each provider has its own specific configuration block within a Terraform configuration file. This block contains information such as authentication details, region, or endpoint, depending on the provider. Read more on [Terraform Providers.](https://developer.hashicorp.com/terraform/language/providers/configuration)

  ```bash
  provider "aws" {
      region = "us-west-2"
  }
  ```

- Providers define a set of resource types that Terraform can manage. Resource types represent specific infrastructure components, such as virtual machines, databases, networks, etc. The resource type corresponds to the underlying service or resource on the target platform.

  Example:

  ```bash
  resource "aws_instance" "example" {
      ami           = "ami-0c55b159cbfafe1f0"
      instance_type = "t2.micro"
  }
  ```

  - In this example, the `aws_instance` resource type is associated with the AWS provider and represents an EC2 instance.

- The version constraint for a provider can be specified in the configuration to control the version used by Terraform.

  Example:

  ```bash
  provider "aws" {
      region  = "us-west-2"
      version = "~> 3.0"
  }
  ```

  - In this example, the provider `version` is constrained to use any version equal or greater than 3.0.

Terraform includes built-in providers for popular cloud platforms like AWS, Azure, Google Cloud, as well as providers for various on-premises infrastructure and services.

Additionally, the Terraform Registry allows users to discover and use **community-contributed** providers for a wide range of platforms and services.

## Extras

- [Github Markdown TOC Generator](https://ecotrust-canada.github.io/markdown-toc/)

- [Terraform Providers.](https://developer.hashicorp.com/terraform/language/providers/configuration)
