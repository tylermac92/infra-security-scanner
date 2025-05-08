resource "aws_key_pair" "default" {
  key_name   = "infra-sec-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "default" {
  id = data.aws_subnets.default.ids[0]
}

resource "aws_instance" "demo" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id              = data.aws_subnet.default.id

  tags = {
    Name = "InfraSecDemo"
  }
}
