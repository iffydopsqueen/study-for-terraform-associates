# Using 'null_resource'
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo 'This is a null resource'"
  }
}