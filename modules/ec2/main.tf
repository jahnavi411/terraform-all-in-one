resource "aws_instance" my_instance {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name = var.name
  }


  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file(var.private_key_path)
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'connected to the insatance'",
      "sudo yum update -y",
      "sudo yum install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "${var.name}-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}
