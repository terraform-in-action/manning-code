//nomad load balancer
resource "aws_lb_target_group" "nomad" {
  name     = "${var.namespace}-nomad"
  port     = 4646
  protocol = "HTTP"
  vpc_id   = var.vpc.vpc_id

  health_check {
    path = "/v1/agent/self"
  }
  tags = {
    ResourceGroup = var.namespace
  }
}

resource "aws_lb_listener" "nomad" {
  load_balancer_arn = aws_lb.nomad_external.arn
  port              = "4646"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.nomad.arn
    type             = "forward"
  }
}

resource "aws_lb" "nomad_external" {
  name            = "${var.namespace}-nomad"
  internal        = false
  security_groups = [var.sg.loadbalancer]
  subnets         = var.vpc.public_subnets
}


//consul load balancer
resource "aws_lb_target_group" "consul" {
  name     = "${var.namespace}-consul-servers"
  port     = 8500
  protocol = "HTTP"
  vpc_id   = var.vpc.vpc_id

  health_check {
    path = "/v1/status/leader"
  }
  tags = {
    ResourceGroup = var.namespace
  }
}

resource "aws_lb_listener" "consul" {
  load_balancer_arn = aws_lb.consul_external.arn
  port              = "8500"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.consul.arn
    type             = "forward"
  }
}

resource "aws_lb" "consul_external" {
  name            = "${var.namespace}-consul"
  internal        = false
  security_groups = [var.sg.loadbalancer]
  subnets         = var.vpc.public_subnets
}