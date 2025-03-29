provider "aws" {
  alias  = "oregon"
  region = "us-west-2"
}

provider "aws" {
  alias  = "london"
  region = "eu-west-2"
}

# VPC Oregon
module "vpc_oregon" {
  source            = "./modules/vpc"
  providers         = { aws = aws.oregon }
  cidr_block        = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

# VPC Londres
module "vpc_london" {
  source            = "./modules/vpc"
  providers         = { aws = aws.london }
  cidr_block        = "10.1.0.0/16"
  subnet_cidr       = "10.1.1.0/24"
  availability_zone = "eu-west-2a"
}

# EC2 Oregon
module "ec2_oregon" {
  source         = "./modules/ec2"
  providers      = { aws = aws.oregon }
  ami            = var.ami_oregon
  instance_type  = var.instance_type
  subnet_id      = module.vpc_oregon.subnet_id
  sg_id          = module.vpc_oregon.sg_id
  name           = "vm-oregon"
}

# EC2 Londres
module "ec2_london" {
  source         = "./modules/ec2"
  providers      = { aws = aws.london }
  ami            = var.ami_london
  instance_type  = var.instance_type
  subnet_id      = module.vpc_london.subnet_id
  sg_id          = module.vpc_london.sg_id
  name           = "vm-london"
}
