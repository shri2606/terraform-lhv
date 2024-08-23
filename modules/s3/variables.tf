 variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
 }

variable "versioning_enabled" {
  description = "Enable versioning for S3 bucket"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
}