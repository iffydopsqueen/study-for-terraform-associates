# Using 'cloud-init'
resource "aws_instance" "web-server" {
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