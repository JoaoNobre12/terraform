terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc_ec2" {
  cidr_block = "172.16.0.0/16"

  tags = {
   name = "my-terraform-vpc"
  }
}

resource "aws_subnet" "my-terraform-subnet-1" {
  vpc_id = aws_vpc.vpc_ec2.id
  cidr_block = "172.16.10.0/24"


}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my-terraform-subnet-1.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "first network interface"
  }
}

resource "aws_instance" "my-terra-ec3" {
  ami = "ami-0dba2cb6798deb6d8"
  instance_type = "t2.micro"
  key_name = "only"
  
  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index = 0
  }
}