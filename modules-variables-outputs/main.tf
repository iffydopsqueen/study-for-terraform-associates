module "web_server" {
    source = "./web_server"
    instance_type = "t2.micro"
    ami = var.my_ami
}

output "instance_ip_addr" {
  value = module.web_server.public_ip
}



