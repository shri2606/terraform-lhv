variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
}



variable "ec2_instance_count" {
  description = "Number of EC2 instances to create"
  default     = 3
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "ec2_ami" {
  description = "AMI ID for EC2 instances"
  default     = "ami-066784287e358dad1"  
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
  default     = "db.t3.medium"
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS instance (in GB)"
  default     = 50
}

