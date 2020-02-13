resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type

  user_data = <<-EOF
    #!/bin/bash 
    mkdir -p /var/www && cd /var/www
    echo "App v${var.version}" >> index.html
    python3 -m http.server 80
  EOF  
}
