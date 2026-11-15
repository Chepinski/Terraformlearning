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
  values = ["al2023-am-2023.*-x86_64"]
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
}

#simply tagging what we made to make it easily searchable
tags{
  Name = "TerraformLearningServer"
}

/*Overview of file
Created an EC2 instance size t2.micro for learning
Instead of plugging in an ID I'd have to find in the
management console (that would make it more difficult
if the server ever changed regions), used the AWS SSM
Parameter store (data, filter, resource)
 */