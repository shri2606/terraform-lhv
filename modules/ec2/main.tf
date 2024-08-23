resource "aws_instance" "main" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
#   key_name               = var.ssh_key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]

  tags = {
    Name = "${var.environment}-ec2-${count.index + 1}"
  }
}