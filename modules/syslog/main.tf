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

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "syslog" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.syslog.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y rsyslog
              
              # Configure rsyslog server
              cat <<'RSYSLOG' > /etc/rsyslog.d/10-remote-logging.conf
              # Provide UDP syslog reception
              module(load="imudp")
              input(type="imudp" port="514")

              # Create separate log files for each host
              template(name="RemoteLogs" type="string" string="/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log")
              *.* ?RemoteLogs
              RSYSLOG

              mkdir -p /var/log/remote
              systemctl restart rsyslog
              EOF
  )

  tags = merge(var.common_tags, {
    Name = "TMMC-Syslog-Server"
  })
}

resource "aws_security_group" "syslog" {
  name        = "syslog-server"
  description = "Security group for syslog server"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = values(var.vpc_cidrs)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "TMMC-Syslog-SG"
  })
}
