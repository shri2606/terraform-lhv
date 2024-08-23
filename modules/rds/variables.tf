
variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage for RDS instance (in GB)"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp2"
}

variable "multi_az" {
  description = "Enable multi-AZ for RDS"
  type        = bool
  default     = true
}



variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the RDS instance"
  type        = list(string)
}