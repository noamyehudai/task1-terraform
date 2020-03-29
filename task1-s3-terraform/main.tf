provider "aws" {
  profile = "default"
  region  = "eu-central-1" ### CHANGE TO 'eu-west-3'
}

terraform {
  backend "s3" {
    bucket = "noam-terraform-bucket"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

# Creating key-pair for SSH connection
resource "aws_key_pair" "example" {
  key_name   = "examplekey"
  public_key = file("~/.ssh/terraform-kp.pub")
}

# Creating EC2 instance within the new VPC
resource "aws_instance" "example" {
  key_name                    = aws_key_pair.example.key_name
  ami                         = "ami-0ec1ba09723e5bfac"
  instance_type               = "t2.micro" ### CHANGE TO 't3a.medium'
  subnet_id                   = aws_subnet.example.id
  vpc_security_group_ids      = ["${aws_security_group.example.id}"]
  associate_public_ip_address = true

  # Saving the instance's IP locally for future use
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }

}
