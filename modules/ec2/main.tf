resource "aws_instance" "main" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  iam_instance_profile = var.iam_instance_profile
  user_data = var.user_data
  tags = {
    Name = "${var.environment}-ec2-${count.index + 1}"
  }
}