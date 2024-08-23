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
  source               = "../modules/ec2"
  instance_count       = var.ec2_instance_count
  subnet_ids           = module.vpc.public_subnet_ids
  instance_type        = var.ec2_instance_type
  ami                  = var.ec2_ami
  security_group_ids   = [module.vpc.public_security_group_id]
  environment          = "prod"
  iam_instance_profile = aws_iam_instance_profile.ec2_cloudwatch_profile.name
  user_data            = <<-EOF
                          #!/bin/bash
                          sudo yum update -y
                          sudo yum install -y amazon-cloudwatch-agent
                          sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<-EOC
                          {
                              "agent": {
                                  "metrics_collection_interval": 60,
                                  "run_as_user": "root"
                              },
                              "logs": {
                                  "logs_collected": {
                                      "files": {
                                          "collect_list": [
                                              {
                                                  "file_path": "/var/log/messages",
                                                  "log_group_name": "/aws/ec2/prod-messages",
                                                  "log_stream_name": "{instance_id}"
                                              }
                                          ]
                                      }
                                  }
                              }
                          }
                          EOC
                          sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
                          EOF
}


module "s3" {
  source = "../modules/s3"

  bucket_name         = "shridharlighthouseprod"
  versioning_enabled  = true
  environment         = "prod"
}

module "rds" {
  source = "../modules/rds"

  instance_class      = var.rds_instance_class
  allocated_storage   = var.rds_allocated_storage
  storage_type        = "gp3"
  multi_az            = true
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpc.private_security_group_id]
  environment         = "prod"
}


module "cloudwatch" {
  source = "../modules/cloudwatch"

  environment      = "prod"
  ec2_instance_ids = module.ec2.instance_ids
  
}

resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "prod-ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
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

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.ec2_cloudwatch_role.name
}

resource "aws_iam_instance_profile" "ec2_cloudwatch_profile" {
  name = "prod-ec2-cloudwatch-profile"
  role = aws_iam_role.ec2_cloudwatch_role.name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high_cpu_utilization_prod"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  
  dimensions = {
    InstanceId = module.ec2.instance_ids[0] # Monitor the first EC2 instance, or loop for all
  }

  alarm_description = "This metric monitors EC2 CPU utilization"
  actions_enabled   = true
}

resource "aws_cloudwatch_log_group" "prod_logs" {
  name              = "/aws/ec2/production"
  retention_in_days = 30
}
