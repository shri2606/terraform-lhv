provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../modules/vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment = "prod"
}

module "ec2" {
  source = "../modules/ec2"

  instance_count     = var.ec2_instance_count
  subnet_ids         = module.vpc.public_subnet_ids
  instance_type      = var.ec2_instance_type
  ami                = var.ec2_ami
  
  security_group_ids = [module.vpc.public_security_group_id]
  environment         = "prod"
}

module "s3" {
  source = "../modules/s3"

  bucket_name         = "shridharlighthouseprod"
  versioning_enabled  = true
  environment         = "prod"
}

module "rds" {
  source = "../modules/rds"

 # engine              = var.engine
  #engine_version      = "16.4"
  instance_class      = var.rds_instance_class
  allocated_storage   = var.rds_allocated_storage
  storage_type        = "gp3"
  multi_az            = true
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpc.private_security_group_id]
  environment         = "prod"
}

resource "aws_cloudwatch_log_group" "prod_logs" {
  name = "/aws/ec2/production"
  retention_in_days = 30
}

resource "aws_iam_role" "cloudwatch_role" {
  name = "prod_cloudwatch_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.cloudwatch_role.name
}