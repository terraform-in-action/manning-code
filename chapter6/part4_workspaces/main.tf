terraform {
  backend "s3" {
    bucket         = "pokemon-q56ylfpq6bzrw3dl-state-bucket"
    key            = "team1/my-cool-project"
    region         = "us-west-2"
    encrypt        = true
    profile        = "swinkler"
    role_arn       = "arn:aws:iam::215974853022:role/pokemon-q56ylfpq6bzrw3dl-tf-assume-role"
    dynamodb_table = "pokemon-q56ylfpq6bzrw3dl-state-lock"
  }
  required_version = "~> 0.12"
  required_providers {
    null = "~> 2.1"
  }
}

variable "region" {
  description = "AWS Region"
  type        = string
}

provider "aws" {
  profile = "swinkler"
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