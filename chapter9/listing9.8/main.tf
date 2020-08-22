output "public_ip" {
 value = aws_instance.ansible_server.public_ip
}

output "ansible_command" {
    value = "ansible-playbook -u ubuntu --key-file ansible-key.pem -T 300 -i '${aws_instance.ansible_server.public_ip},', app.yml"
}
