module "web_server" {
    source = "./web_server"
    instance_type = "t2.micro"
    my_ami = "ami-0cd5f46e93e42a496"
}

output "instance_ip_addr" {
  value = module.web_server.public_ip
}



