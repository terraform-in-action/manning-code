/*data "shell_script" "test1" {
	lifecycle_commands {
		read = <<EOF
		echo '{"commit_id": "b8f2b8b"}' >&3
		EOF
	}
}*/

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
