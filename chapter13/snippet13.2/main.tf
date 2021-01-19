resource "aws_instance" "helloworld" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}
