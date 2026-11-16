terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws"{
  region = "us-east-1"
}

#automatically fetch the latest Amazon Linux 2023 AMI for region
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
filter {
  name = "name" #we are filtering by the name of the AMI
  values = ["al2023-ami-2023.*-x86_64"]
  }
}
#instead of fetching a valid ami id from the
#mngmt console and plugging it directly in,
#use aws ssm parameter store
#this is dynamic...this is good
#linux will be used
resource "aws_instance" "terraform_test"{
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  #attach security group to instance
  vpc_security_group_ids = [aws_security_group.instance.id]
#simply tagging what we made to make it easily searchable
tags = {
  Name = "TerraformLearningServer"
}
}

variable "port_number" {#remember the DRY principle
  description = "port used for server requests"
  type = number
  default = 8080
}

resource "aws_security_group" "instance" {
  name = "terraform-learner-server"

  ingress {
    from_port = var.port_number
    to_port = var.port_number
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    #-1 means all protocols
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/*Overview of file
1. Created an EC2 instance size t2.micro for learning
Instead of plugging in an ID I'd have to find in the
management console (that would make it more difficult
if the server ever changed regions), used the AWS SSM
Parameter store (data, filter, resource)
 2. Created Security Group
 */