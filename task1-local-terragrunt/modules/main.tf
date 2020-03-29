# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE VPC 
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# Define the public subnet
resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

# Define the internet gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

# Define the route table
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}

# Define the security group for public subnet
resource "aws_security_group" "example" {
  name        = "vpc_example"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE EC2
# ---------------------------------------------------------------------------------------------------------------------

# Creating key-pair for SSH connection
resource "aws_key_pair" "example" {
  key_name   = "examplekey"
  public_key = file("~/.ssh/terraform-kp.pub")
}

# Creating EC2 instance within the new VPC
resource "aws_instance" "example" {
  key_name                    = aws_key_pair.example.key_name
  ami                         = "ami-0ec1ba09723e5bfac"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.example.id
  vpc_security_group_ids      = ["${aws_security_group.example.id}"]
  associate_public_ip_address = true

}
