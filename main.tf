    # Proveedor AWS
    provider "aws" {
    alias  = "oregon"
    region = "us-west-2"
    }

    provider "aws" {
    alias  = "london"
    region = "eu-west-2"
    }

    # VPC (misma configuración en ambas regiones)
    resource "aws_vpc" "custom_vpc_oregon" {
    provider = aws.oregon
    cidr_block = "10.0.0.0/16"
    }

    resource "aws_vpc" "custom_vpc_london" {
    provider = aws.london
    cidr_block = "10.1.0.0/16"
    }

    # Subnet
    resource "aws_subnet" "subnet_oregon" {
    provider                = aws.oregon
    vpc_id                  = aws_vpc.custom_vpc_oregon.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-west-2a"
    }

    resource "aws_subnet" "subnet_london" {
    provider                = aws.london
    vpc_id                  = aws_vpc.custom_vpc_london.id
    cidr_block              = "10.1.1.0/24"
    availability_zone       = "eu-west-2a"
    }

    # Grupo de seguridad
    resource "aws_security_group" "sg_common" {
    name        = "common-firewall"
    description = "Allow SSH (22) and RDP (3389)"
    vpc_id      = aws_vpc.custom_vpc_oregon.id
    provider    = aws.oregon

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "RDP"
        from_port   = 3389
        to_port     = 3389
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

    resource "aws_security_group" "sg_common_london" {
    name        = "common-firewall"
    description = "Allow SSH (22) and RDP (3389)"
    vpc_id      = aws_vpc.custom_vpc_london.id
    provider    = aws.london

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "RDP"
        from_port   = 3389
        to_port     = 3389
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

# EC2 en Oregon
resource "aws_instance" "ec2_oregon" {
  provider          = aws.oregon
  ami               = var.ami_oregon
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.subnet_oregon.id
  vpc_security_group_ids = [aws_security_group.sg_common.id]
  tags = {
    Name = "vm-oregon"
  }
}

# EC2 en Londres
resource "aws_instance" "ec2_london" {
  provider          = aws.london
  ami               = var.ami_london
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.subnet_london.id
  vpc_security_group_ids = [aws_security_group.sg_common_london.id]
  tags = {
    Name = "vm-london"
  }
}

