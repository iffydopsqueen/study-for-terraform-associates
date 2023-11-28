# Using 'file' provisioner
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "file" {
    source      = "local/path/to/file.txt"
    destination = "/remote/path/file.txt"
  }
}