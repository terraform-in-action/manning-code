provider "aws" {
  version = "2.12.0"
  region  = "us-west-2"
}

resource "aws_instance" "helloworld" {
  ami           = "ami-944162ec"
  instance_type = "t2.micro"
}
