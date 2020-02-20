data "shell_script" "user" {
  lifecycle_commands {
    read = <<EOF
echo "{\"user\": \"$(whoami)\"}" >&3
EOF
  }
}

output "user" {
  value = data.shell_script.user.output["user"]
}