variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "ec2_instance_ids" {
  description = "List of EC2 instance IDs to monitor"
  type        = list(string)
}

