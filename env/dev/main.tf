provider "aws" {
  region = "us-west-2"
}

module "ec2" {
  source = "../../modules/ec2"
  ami = var.ami
  instance_type = var.instance_type
  name = "dev_server"
  key_name = var.key_name
  private_key_path = var.private_key_path
}

output "public_ip" {
  value = module.ec2.public_ip
}

terraform {
  backend "s3" {}
}
