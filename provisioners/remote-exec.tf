# Using 'remote-exec'
resource "aws_instance" "web-server" {
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