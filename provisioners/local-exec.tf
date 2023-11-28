# Using 'local-exec'
resource "aws_instance" "web-server" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    provisioner "local-exec" {
    command = "echo 'Hello, World!'"
    }
}