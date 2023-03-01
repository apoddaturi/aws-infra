
resource "aws_security_group" "sg" {
  name_prefix = "app-sg"
  vpc_id      = var.vpc_id
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
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "application"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "ec2_dev-${timestamp()}"
  public_key = var.ssh_key
}

resource "aws_instance" "example" {
  ami                     = var.ami_val
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.sg.id]
  subnet_id               = var.public_subnets_ids[0]
  key_name                = aws_key_pair.deployer.key_name
  disable_api_termination = true

  root_block_device {
    volume_size           = 50
    volume_type           = "gp2"
    delete_on_termination = false
  }
  tags = {
    "Name" = "Ec2_Terraform-${timestamp()}"
  }

}