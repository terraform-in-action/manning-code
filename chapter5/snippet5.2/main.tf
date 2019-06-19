resource "null_resource" "l33t" {
    triggers = {
        always = timestamp()
    }

    provisioner "local-exec" {
        command = "echo hello"
    }

    provisioner "local-exec" {
        when = "destroy"
        command = "echo goodbye"
    }
}