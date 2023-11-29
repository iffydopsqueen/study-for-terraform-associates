# Terraform Variables, Outputs & Modules

**Table of Contents**

- [Terraform Variables](#terraform-variables)
  - [String](#string)
  - [Number](#number)
  - [Lists](#lists)
  - [Map](#map)
  - [Bool](#bool)
  - [Object](#object)
  - [Tuple](#tuple)
  - [Set](#set)
  - [Using Variables in Resource Blocks](#using-variables-in-resource-blocks)
  - [Variable Validation](#variable-validation)
- [Terraform Outputs](#terraform-outputs)
  - [Multiple Outputs](#multiple-outputs)
  - [Using Outputs in CLI](#using-outputs-in-cli)
- [Terraform Modules](#terraform-modules)
  - [Module Structure](#module-structure)
  - [Defining Variables in a Module](#defining-variables-in-a-module)
  - [Defining Resources in a Module](#defining-resources-in-a-module)
  - [Using a Module in a Configuration](#using-a-module-in-a-configuration)
- [Extras](#extras)

## Terraform Variables

Terraform Variables are a way to parameterize your configurations. They allow you to define values that can be passed into and used by your modules.

Variables can be used to make your Terraform configurations more flexible and reusable. Read more on [Terraform Variables.](https://developer.hashicorp.com/terraform/language/values/variables)

Variables can be of various types, and each type serves a specific purpose. Here are some of the common variable types in Terraform, along with examples:

### String

String variables are used for representing textual data. They are commonly used for labels, names, or descriptions.

```bash
variable "environment" {
  type        = string
  description = "The environment for the infrastructure"
  default     = "production"
}
```

### Number

Number variables are used for representing numerical values. They can be used for specifying quantities or any numeric configuration.

```bash
variable "instance_count" {
  type        = number
  description = "The number of instances to launch"
  default     = 3
}
```

### Lists

List variables allow you to define an ordered collection of values. They are useful for providing a set of values, such as a list of security group names.

```bash
variable "security_groups" {
  type        = list(string)
  description = "List of security group names"
  default     = ["sg-12345678", "sg-87654321"]
}
```

### Map

Map variables allow you to define a set of key-value pairs. They are commonly used for passing structured data, like tags for resources.

```bash
variable "tags" {
  type        = map(string)
  description = "A map of key-value pairs for resource tags"
  default     = {
    Name        = "MyInstance"
    Environment = "Production"
  }
}
```

### Bool

Bool variables are used for representing boolean values (true or false). They are often used for conditional logic.

```bash
variable "enable_logging" {
  type        = bool
  description = "Flag to enable/disable logging"
  default     = true
}
```

### Object

Object variables allow you to define a complex data structure with multiple attributes. They are useful for grouping related configuration values.

```bash
variable "subnet" {
  type = object({
    cidr_block = string
    availability_zone = string
  })
  description = "Configuration for a subnet"
  default = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-west-2a"
  }
}
```

### Tuple

Tuple variables allow you to define an ordered collection of elements with a fixed number of elements. They are similar to lists but have a specific number of elements.

```bash
variable "subnet_cidr_blocks" {
  type        = tuple([string, string])
  description = "Tuple of primary and secondary subnet CIDR blocks"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
```

### Set

Set variables allow you to define an unordered collection of unique values. They are useful when the order of elements doesn't matter, and each element should be unique.

```bash
variable "allowed_ports" {
  type        = set(number)
  description = "Set of allowed ports"
  default     = [80, 443]
}
```

### Using Variables in Resource Blocks

Once you define variables, you can use them in resource blocks. For example:

```bash
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.instance_count
}
```

### Variable Validation

You can also add validation rules to variables using the `validation` block:

```bash
variable "instance_type" {
  type        = string
  description = "The instance type"
  validation {
    condition     = can(regex("^t2.", var.instance_type))
    error_message = "Instance type must start with 't2.'"
  }
}
```

In this example, the variable `instance_type` must start with `"t2."` according to the specified validation condition.

Remember, choosing the right variable type depends on the kind of data you want to represent and how you plan to use it in your Terraform configuration.

## Terraform Outputs

Terraform Outputs allow you to expose selected values from your Terraform configuration or modules.

Outputs are useful for providing information about the infrastructure that was created or modified. These outputs can be accessed and used by other Terraform configurations, scripts, or external systems. Read more on [Terraform Outputs.](https://developer.hashicorp.com/terraform/language/values/outputs)

Here's how you can define outputs in Terraform:

```bash
output "instance_ip" {
  value = aws_instance.web_server.public_ip
}
```

In this example:

- `output` is the keyword used to define an output.
- `"instance_ip"` is the name of the output variable.
- `value` specifies the value of the output, in this case, the public IP address of an AWS EC2 instance named `web_server`.

### Multiple Outputs

You can define multiple outputs in a single Terraform configuration or module. This allows you to expose multiple pieces of information from your infrastructure.

```bash
output "instance_ip" {
  value = aws_instance.web_server.public_ip
  description = "Public IP address of the instance"
}

output "instance_id" {
  value = aws_instance.web_server.id
  description = "Instance ID of the web server"
}
```

### Using Outputs in CLI

After applying your Terraform configuration, you can use the `terraform output` command to view the values of your defined outputs.

```bash
# view all outputs
terraform output

# view a specific output
terraform output instance_ip

# view output as JSON
terraform output -json

# output to a file
terraform output instance_ip > output.txt

# use output in subsequent commands
terraform apply -var="external_ip=$(terraform output instance_ip)"
```

These are some of the common ways you can use Terraform outputs in the command line interface.

The flexibility of Terraform outputs allows you to integrate them seamlessly into your workflow and use them as needed.

In summary, Terraform outputs provide a way to share information from your infrastructure with other parts of your configuration or external systems. They enhance modularity and enable you to create more flexible and reusable configurations.

## Terraform Modules

Terraform modules are a way to organize and reuse code. A module is a self-contained collection of Terraform configurations and can represent a set of resources and associated logic.

Modules can be used to encapsulate infrastructure components and make your configurations more modular and maintainable. Read more on [Terraform Modules.](https://developer.hashicorp.com/terraform/language/modules)

### Module Structure

Example of module structure:

```bash
/modules
  /web_server
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
```

In this example, the `web_server` directory is a module. It contains `main.tf` for resource definitions, `variables.tf` for variable definitions, and `outputs.tf` for output definitions.

### Defining Variables in a Module

In `variables.tf`, you define the input variables that your module expects. These variables can have default values or be provided depends on your needs.

Example `(modules/web_server/variables.tf)`:

```bash
variable "instance_type" {
  type        = string
  description = "The type of EC2 instance to launch"
}

variable "ami_id" {
  type        = string
  description = "The ID of the Amazon Machine Image (AMI) to use"
  default     = "ami-0c55b159cbfafe1f0"
}
```

### Defining Resources in a Module

Modules can be used by other configurations. In `main.tf`, you define the resources or infrastructure components that the module manages. You can use the variables defined in `variables.tf` to parameterize the resource configurations.

Example `(modules/web_server/main.tf)`:

```bash
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "WebServer"
  }
}
```

In `outputs.tf`, you define the values that you want to expose from the module. These outputs can be used by the calling configuration.

Example `(modules/web_server/outputs.tf)`:

```bash
output "public_ip" {
  value = aws_instance.web_server.public_ip
}
```

### Using a Module in a Configuration

In the root-level Terraform configuration, you use the `module` block to instantiate and use the module. You provide values for the variables defined in the module.

Example (`main.tf` in the root configuration):

```bash
module "web_server" {
  source        = "./web_server"
  instance_type = "t2.micro"
  ami_id        = "ami-0123456789abcdef0"
}

output "web_server_ip" {
  value = module.web_server.public_ip
}
```

Terraform modules provide a powerful way to structure and reuse infrastructure code.

They promote modularity, maintainability, and collaboration in large-scale infrastructure projects.

The ability to parameterize modules with variables and share information through outputs makes them a key feature in creating scalable and modular Terraform configurations.

## Extras

- [Github Markdown TOC Generator](https://ecotrust-canada.github.io/markdown-toc/)

- [Terraform Variables.](https://developer.hashicorp.com/terraform/language/values/variables)

- [Terraform Outputs.](https://developer.hashicorp.com/terraform/language/values/outputs)

- [Terraform Modules.](https://developer.hashicorp.com/terraform/language/modules)
