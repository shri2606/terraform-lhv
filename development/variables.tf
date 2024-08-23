variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances to create"
  default     = 2
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ec2_ami" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0c94855ba95c71c99"  # Amazon Linux 2 AMI (adjust for your region)
}

# variable "ssh_key_name" {
#   description = "Name of the SSH key pair to use for EC2 instances"
# }

# variable "s3_bucket_name" {
#   description = "Name of the S3 bucket"
# }

variable "s3_versioning_enabled" {
  description = "Enable versioning for S3 bucket"
  default     = true
}

variable "rds_engine" {
  description = "RDS engine type"
  default     = "postgres"
}

variable "rds_engine_version" {
  description = "RDS engine version"
  default     = "16.4"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "rds_storage_type" {
  description = "RDS storage type"
  default     = "gp2"
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS instance (in GB)"
  default     = 20
}

variable "rds_multi_az" {
  description = "Enable multi-AZ for RDS"
  default     = true
}

# variable "rds_db_name" {
#   description = "Name of the database"
# }

# variable "rds_db_username" {
#   description = "Username for the database"
# }

# variable "rds_db_password" {
#   description = "Password for the database"
# }