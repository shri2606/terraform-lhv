variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

variable "ami" {
  description = "AMI ID for EC2 instances"
}

variable "instance_type" {
  description = "EC2 instance type"
}

# variable "ssh_key_name" {
#   description = "Name of the SSH key pair to use for EC2 instances"
# }

variable "security_group_ids" {
  description = "List of security group IDs to attach to EC2 instances"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs to launch EC2 instances in"
  type        = list(string)
}