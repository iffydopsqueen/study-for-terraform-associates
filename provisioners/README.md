# Terraform Provisioners

**Table of Contents**

- [Terraform Provisioners](#terraform-provisioners)
  - [Terraform Provisioners ToolKit](#terraform-provisioners-toolkit)
    - [Cloud-Init](#cloud-init)
    - [Local-Exec Provisioner](#local-exec-provisioner)
    - [Remote-Exec Provisioner](#remote-exec-provisioner)
    - [File Provisioner](#file-provisioner)
    - [Connection Block](#connection-block)
    - [Null Resources](#null-resources)
    - [Terraform Data](#terraform-data)
- [Extras](#extras)

## Terraform Provisioners

Terraform Provisioners are a feature that allows you to execute scripts or commands on a remote resource after it's been created. Provisioners enable you to perform tasks such as software installations, configuration management, or any other actions that need to happen on the resource post-creation. Read more on [Terraform Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Terraform Provisioners ToolKit

#### Cloud-Init

- A provisioner using `cloud-init` refers to the use of `cloud-init` configuration to initialize and configure a virtual machine or an instance created by Terraform.

- Cloud-init is a widely used multi-distribution package for cloud instances that supports various cloud providers, including AWS, Azure, Google Cloud, and others.

- When you use `cloud-init` with Terraform provisioners, you are leveraging a `cloud-init` script to perform the setup and configuration of your virtual machine.

- This script is typically passed as `user data` to the cloud provider when launching an instance.

Example:

```bash
resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    user_data = <<-EOF
                #cloud-config
                package_upgrade: true
                packages:
                    - nginx
                    - git
                runcmd:
                    - systemctl start nginx
                    - git clone https://github.com/example/repo.git /var/www/html
                EOF
    }
```

- In this example:

  - The `user_data` argument is used to specify the `cloud-init` configuration script.

  - The `cloud-init` script is written in YAML format.

  - The script includes instructions to upgrade packages, install `nginx` and `git`, and run a series of commands.

  - When the instance is launched, the `cloud-init` script is executed, configuring the instance according to the specified instructions.

- This approach is beneficial for various tasks such as installing software, configuring users, setting up SSH keys, and more. Cloud-init scripts are versatile and allow you to define the initial state of your instances in a declarative manner.

**Note:** It's important to note that while cloud-init can be a powerful tool, the specific features and options available may vary between cloud providers.

Additionally, some cloud providers may have their own mechanisms for providing user data or initialization scripts.

Always refer to the documentation of the specific cloud provider you are working with for details on how to use cloud-init or similar tools.

#### Local-Exec Provisioner

- The local-exec provisioner allows you to run arbitrary commands on the machine running Terraform.

- It is typically used for tasks that need to be executed on the machine where Terraform is executed, rather than on the newly created resource. Read more on [Local-Exec Provisioner.](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

Example:

```bash
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo 'Hello, World!'"
  }
}
```

- In this example, the `local-exec` provisioner runs the `echo 'Hello, World!'` command on the machine running Terraform after the AWS instance is created.

#### Remote-Exec Provisioner

- The `remote-exec` provisioner allows you to run commands on the remote resource via SSH or WinRM (Windows Remote Management).

- It is commonly used for tasks such as configuring software, copying files, or executing commands on the newly created resource. Read more on [Remote-Exec Provisioner.](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

Example:

```bash
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "echo 'Hello, World!' > /var/www/html/index.html",
    ]
  }
}
```

- In this example, the `remote-exec` provisioner runs a series of commands on the AWS instance after it is created. These commands `install nginx` and create a simple `"Hello, World!"` HTML file.

#### File Provisioner

- The `file` provisioner in Terraform are used to copy files or directories from the machine where Terraform is executed to a resource created by Terraform.

- This is often useful when you need to transfer configuration files, scripts, or any other files to a remote resource.

- File provisioners are commonly used in conjunction with `remote-exec` provisioners to set up and configure resources. Read more on [File Provisioner.](https://developer.hashicorp.com/terraform/language/resources/provisioners/file)

Example:

```bash
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "file" {
    source      = "local/path/to/file.txt"
    destination = "/remote/path/file.txt"
  }
}
```

- In this example, the `file` provisioner copies the local file `"file.txt"` to the `"/remote/path/"` directory on the newly created AWS instance.

#### Connection Block

- The `connection` block in Terraform is used to configure how Terraform communicates with a remote resource.

- It's often used in conjunction with provisioners that require a connection to the resource, such as `remote-exec` provisioners.

- The `connection` block allows you to specify details such as the type of connection (SSH or WinRM), authentication details, and other connection-specific settings. Read more on [Provisioner Connection.](https://developer.hashicorp.com/terraform/language/resources/provisioners/connection)

Example:

```bash
resource "aws_instance" "example" {
   ami           = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"

   provisioner "remote-exec" {
     inline = [
       "echo 'Hello, World!' > /tmp/hello.txt",
     ]

     connection {
       type        = "ssh"
       user        = "ec2-user"
       private_key = file("~/.ssh/id_rsa")
       host        = self.public_ip
     }
   }
 }
```

- In this example:

  - The `remote-exec` provisioner is used to execute a simple command, echoing `"Hello, World!"` to a file on the remote instance.

  - The `connection` block is used to specify the connection details.

    - `type` specifies the type of connection (in this case, SSH).

    - `user` specifies the SSH username.

    - `private_key` specifies the path to the private key for authentication.

    - `host` specifies the hostname or IP address of the remote instance. Here, `self.public_ip` is used to dynamically retrieve the public IP address of the created AWS instance.

#### Null Resources

- Null resources in Terraform are resources that don't correspond to a physical infrastructure component but are used to `trigger` actions, such as running provisioners or executing local scripts.

- They are often used when there's a need to perform certain tasks that don't map directly to a specific resource type. Read more on [Provisioners Without a Resource.](https://developer.hashicorp.com/terraform/language/resources/provisioners/null_resource)

Example:

```bash
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo 'This is a null resource'"
  }
}
```

- In this example, the `null_resource` is used to execute a local command `echo` when the Terraform configuration is applied.

#### Terraform Data

- The `data` block in Terraform is used to retrieve and use data from remote sources or external systems during the Terraform execution.

- This can include querying APIs, reading data from files, or fetching information from other Terraform configurations.

- The retrieved data can then be used in various parts of your Terraform configuration. Read more on [Using Terraform Data.](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

Example:

```bash
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
}
```

- In this example, the `data` block is used to query AWS for the latest Amazon Linux AMI, and the resulting AMI ID is then used when creating an AWS instance.

**Note:** It's important to note that while provisioners can be helpful, they should be used with caution. Using provisioners tightly couples your Terraform configuration to specific implementation details, and it may make your infrastructure less declarative.

Whenever possible, it's recommended to use native Terraform resources and modules to define your infrastructure in a declarative manner. Provisioners should be used as a **last resort** when there's no other way to achieve a specific task using native Terraform resources (**_Reason:_** Provisioners will do something that won’t be reflected in the terraform state. A better alternative is to use cloud-provider features like `cloud-init` scripts ~**Andrew Babenko**).

## Extras

- [Github Markdown TOC Generator](https://ecotrust-canada.github.io/markdown-toc/)

- [Terraform Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)
