terraform {
  backend "s3" {
    bucket         = "team-rocket-1qh28hgo0g1c-state-bucket"
    key            = "team1/my-cool-project"
    region         = "us-west-2"
    encrypt        = true
    profile        = "swinkler" # this should be changed.
    role_arn       = "arn:aws:iam::215974853022:role/team-rocket-1qh28hgo0g1c-tf-assume-role"
    dynamodb_table = "team-rocket-1qh28hgo0g1c-state-lock"
  }
  required_version = ">= 0.15"
}

variable "region" {
  description = "AWS Region"
  type        = string
}

provider "aws" {
  region  = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = terraform.workspace
  }
}