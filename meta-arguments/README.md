# Terraform Meta-Arguments

**Table of Contents**

- [Resource Meta-Arguments](#resource-meta-arguments)
  - [Count](#count)
  - [Depends On](#depends-on)
  - [For Each](#for-each)
  - [Lifecycle](#lifecycle)
    - [1. `create_before_destroy`](#1--create-before-destroy-)
    - [2. `prevent_destroy`](#2--prevent-destroy-)
    - [3. `ignore_changes`](#3--ignore-changes-)
- [Extras](#extras)

## Resource Meta-Arguments

Resource Meta-arguments are used to control the behavior of individual resources within a Terraform configuration.

These meta-arguments provide additional options and settings specific to each resource.

Here are some common resource meta-arguments along with examples:

### Count

The `count` meta-argument allows you to create multiple instances of a resource based on a numeric value. Read more [here](https://developer.hashicorp.com/terraform/language/meta-arguments/count)

```bash
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  count         = 3
}
```

- In this example, `3` EC2 instances will be created based on the specified AMI and instance type.

### Depends On

The `depends_on` meta-argument specifies a list of resources that this resource depends on. Terraform will make sure that the specified resources are created or updated before this resource. Read more [here](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)

```bash
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

resource "aws_security_group" "web_sg" {
  // Configuration for the security group

  depends_on = [
    aws_instance.web_server
  ]
}
```

- In this example, the security group resource depends on the EC2 instance, ensuring that the instance is created before the security group.

### For Each

The `for_each` meta-argument in Terraform allows you to create multiple instances of a resource dynamically based on a map or a set of key-value pairs.

It is particularly useful when you want to manage a variable number of similar resources with distinct configurations. Read more [here](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

Here's an example of how for_each is used:

```bash
resource "aws_instance" "server" {
  for_each = {
    web1 = { ami = "ami-0c55b159cbfafe1f0", instance_type = "t2.micro" }
    web2 = { ami = "ami-0c55b159cbfafe1f0", instance_type = "t2.nano" }
    db   = { ami = "ami-0c55b159cbfafe1f0", instance_type = "t2.small" }
  }

  ami           = each.value.ami
  instance_type = each.value.instance_type

  tags = {
    Name = each.key
  }
}
```

In this example:

- The `aws_instance` resource uses the `for_each` meta-argument to dynamically create instances based on the keys and values, where each key represents a unique identifier for a server, and the corresponding value is a set of configuration parameters (AMI and instance type).

- The `each.key` and `each.value` references within the `resource` block allow you to access the current key-value pair during resource creation.

- The `tags` block ensures that each instance is tagged with a unique identifier.

- When you apply this Terraform configuration, it will create instances for each entry in the `for_each` argument, effectively creating `3` instances with the specified configurations.

Using `for_each` provides a more dynamic and scalable way to manage resources, especially when the number of instances is not known in advance or can change over time.

### Lifecycle

The `lifecycle` block is used to configure certain aspects of a resource's lifecycle, such as preventing the resource from being destroyed. Read more [here](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

There are several arguments you can use within the `lifecycle` block, but three notable ones are:

#### 1. `create_before_destroy`

This argument controls whether Terraform should create a new instance of the resource before destroying the existing one during an update.

It is particularly useful when replacing resources with minimal downtime.

Example:

```bash
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}
```

- With `create_before_destroy` set to `true`, Terraform will provision a new EC2 instance before destroying the existing one, minimizing downtime during updates.

#### 2. `prevent_destroy`

If set to `true`, this argument prevents Terraform from destroying the resource during a subsequent apply. It provides an additional layer of protection against accidental deletions.

Example:

```bash
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  lifecycle {
    prevent_destroy = true
  }
}
```

- With `prevent_destroy` set to `true`, Terraform will refuse to destroy this EC2 instance, and attempts to do so will result in an error.

#### 3. `ignore_changes`

This argument allows you to specify a list of attribute names for which Terraform should ignore changes during an update. It is useful when certain attributes should be managed outside of Terraform.

Example:

```bash
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  lifecycle {
    ignore_changes = ["tags"]
  }
}
```

- In this example, changes to the `tags` attribute of the EC2 instance will be ignored during updates. This is helpful when you want to manage certain attributes manually.

These `lifecycle` arguments provide fine-grained control over how Terraform manages resources during updates, ensuring that the process aligns with your specific requirements and constraints.

## Extras

- [Github Markdown TOC Generator](https://ecotrust-canada.github.io/markdown-toc/)

- ["count" Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/count)

- ["depends_on" Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)

- ["for_each" Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

- ["lifecycle" Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
