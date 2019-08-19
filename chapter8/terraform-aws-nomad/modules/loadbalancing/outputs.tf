output "consul_group_arn" {
  value = aws_lb_target_group.consul.arn
}

output "nomad_group_arn" {
  value = aws_lb_target_group.nomad.arn
}

output "lb_dns_names" {
  value = {
    consul = "${aws_lb.consul_external.dns_name}:8500"
    nomad  = "${aws_lb.nomad_external.dns_name}:4646"
  }
}
