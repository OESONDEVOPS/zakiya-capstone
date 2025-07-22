provider "aws" {
  region = "ap-southeast-2"
}


resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "devops-vpc"
  }
}



resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name = "devops-igw"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-b"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-sg"
  description = "Allow SSH, HTTP, and NodePort traffic"
  vpc_id      = aws_vpc.devops_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
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
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "NodePort"
    from_port   = 30000
    to_port     = 32767
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
    Name = "devops-sg"
  }
}

resource "aws_instance" "jenkins_host" {
  ami           = "ami-00839deb72faa8a04" # Amazone Linux
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.devops_sg.id]
  key_name      = "capstoneKeyPair" # Replace with your key pair name
  tags = {
    Name = "jenkins-host"
  }

  user_data =  <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install nginx1 -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Hello from EC2 Instance 2!</h1>" | sudo tee /usr/share/nginx/html/index.html
              EOF
}




resource "aws_instance" "k8s_node1" {
  ami           ="ami-00839deb72faa8a04" # Amazone Linux
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.devops_sg.id]
  key_name      = "capstoneKeyPair" # Replace with your key pair name
  tags = {
    Name = "k8s-node1"
  }
}

resource "aws_instance" "k8s_node2" {
  ami           = "ami-00839deb72faa8a04" # Amazone Linux
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_b.id
  vpc_security_group_ids = [aws_security_group.devops_sg.id]
  key_name      = "capstoneKeyPair" # Replace with your key pair name
  tags = {
    Name = "k8s-node2"
  }
}

