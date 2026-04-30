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
    user = "ec2-user"
    private_key = file(var.private_key_path)
    host = self.public_ip
  }

  #local provisioner
  provisioner "local-exec" {
    command = "echo ${aws_instance.my_instance.public_ip} >> /tmp/ips.txt"
  }

  #Remote Provisioner
  provisioner "remote-exec" {
    inline = [
      "echo 'connected to the insatance'",
      "sudo yum update -y"
    ]
    on_failure = continue
  }

  #File provisioner
  provisioner "file" {
    source      = "/home/ubuntu/test.txt"
    destination = "/home/ec2-user"
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
