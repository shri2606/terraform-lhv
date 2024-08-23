provider "aws" {
  region = var.aws_region
}




terraform {
  backend "s3" {
    bucket         = "shridharlighthousedevstatefile"
    key            = "terraform/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks-dev"
  }
}

module "vpc" {
  source = "../modules/vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = "dev"
}

module "ec2" {
  source = "../modules/ec2"

  instance_count     = var.ec2_instance_count
  subnet_ids         = module.vpc.public_subnet_ids
  instance_type      = var.ec2_instance_type
  ami                = var.ec2_ami
#   ssh_key_name       = var.ssh_key_name
  security_group_ids = [module.vpc.public_security_group_id]
  environment          = "dev"
}

module "s3" {
  source = "../modules/s3"

  bucket_name         = "shridharlighthousedev"
  versioning_enabled  = var.s3_versioning_enabled
  environment          = "dev"
}

module "rds" {
  source = "../modules/rds"

#   engine              = "Postgres"
#   engine_version      = "16.4"
  instance_class      = var.rds_instance_class
  storage_type        = var.rds_storage_type
  allocated_storage   = var.rds_allocated_storage
  multi_az            = var.rds_multi_az
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpc.private_security_group_id]
  environment          = "dev"
#   db_name             = var.rds_db_name
#   db_username         = var.rds_db_username
#   db_password         = var.rds_db_password
}