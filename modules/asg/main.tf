terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "web" {
  name_prefix   = "${var.region_name}-web-lt"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.security_group_id]
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    region_name     = var.region_name,
    syslog_server_ip = var.syslog_server_ip
  }))

  tags = merge(var.common_tags, {
    Name = "${var.region_name}-web-server"
  })
}

resource "aws_autoscaling_group" "web" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  target_group_arns   = [var.target_group_arn]
  vpc_zone_identifier = var.private_subnet_ids
  health_check_grace_period = 300
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.region_name}-web-asg"
    propagate_at_launch = true
  }

  depends_on = [
    var.vpc_id,  
    var.syslog_server_id,  
    var.transit_gateway_id,  
    var.target_group_arn  
  ]

}
