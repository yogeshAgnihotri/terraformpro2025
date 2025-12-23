## 1. Create vpc =======================================
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}
##Create Subnet =========================================
resource "aws_subnet" "dev-subnet" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.az}"
  tags = {
    Name = "dev-subnet"
  }
}
## create igw ============================================
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
        Name = "dev-igw"
    }
}
##Create Custom Route Table ========================================
resource "aws_route_table" "dev-route-table" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.dev-igw.id
  }

  tags = {
    Name = "dev-route-table"
  }
}
##Associate subnet with Route Table ======================================
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dev-subnet.id
  route_table_id = aws_route_table.dev-route-table.id
}
## Create Security Group =====================================================
resource "aws_security_group" "allow-web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
      }
  ingress {
    description = "custom"
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
      }
  ingress {
    description = "SSH"
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
  tags = {
    Name = "allow-web"
  }
}


## Create node1 server ======================================================================
resource "aws_instance" "node1-server" {
  ami               = "${var.AWS_AMI}"
  instance_type     = "t2.micro"
  vpc_security_group_ids =[aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet.id
  monitoring             = false
  key_name          = "${var.pkey}"
  user_data = file("${path.module}/node.sh")
  tags = {
    Name = "node1-server"
  }
}
## Create node2 server ======================================================================
resource "aws_instance" "node2-server" {
  ami               = "${var.AWS_AMI}"
  instance_type     = "t2.micro"
  vpc_security_group_ids =[aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet.id
  monitoring             = false
  key_name          = "${var.pkey}"
  user_data = file("${path.module}/node.sh")
  tags = {
    Name = "node2-server"
  }
}
## Create node3 server ======================================================================
resource "aws_instance" "node3-server" {
  ami               = "${var.AWS_AMI}"
  instance_type     = "t2.micro"
  vpc_security_group_ids =[aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet.id
  monitoring             = false
  key_name          = "${var.pkey}"
  user_data = file("${path.module}/node.sh")
  tags = {
    Name = "node3-server"
  }
}

## Create ansible server ======================================================================
## Create ansible server ======================================================================
resource "aws_instance" "ansible-server" {
  ami               = "${var.AWS_AMI}"
  instance_type     = "t2.micro"
  vpc_security_group_ids =[aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet.id
  monitoring             = false
  key_name          = "${var.pkey}"
  user_data = file("${path.module}/ansible.sh")
  connection {
    type     = "ssh"
    user     = "root"
    password = var.rpass
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "echo '${aws_instance.node1-server.private_ip} node1' >> /etc/hosts",
      "echo '${aws_instance.node2-server.private_ip} node2' >> /etc/hosts",
      "echo '${aws_instance.node3-server.private_ip} node3' >> /etc/hosts"
    ]
  }
   tags = {
    Name = "ansible-server"
  }
}

