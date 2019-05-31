resource "aws_instance" "helloworld" {
  ami           = "ami-944162ec"
  instance_type = "t2.micro"
}
