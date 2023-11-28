# Using 'null_resource'
resource "null_resource" "web-server" {
  provisioner "local-exec" {
    command = "echo 'This is a null resource'"
  }
}