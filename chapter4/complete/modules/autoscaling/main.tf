module "iam_instance_profile" {
  source  = "scottwinkler/iip/aws"
  actions = ["logs:*", "s3:*", "rds:*"]
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud_config.yaml", var.db_config)
  }
}

resource "aws_launch_template" "webserver" {
  name_prefix   = var.namespace
  image_id      = "ami-7172b611"
  instance_type = "t2.medium"
  user_data     = data.template_cloudinit_config.config.rendered
  iam_instance_profile {
    name = module.iam_instance_profile.name
  }
  vpc_security_group_ids = [var.sg.websvr]
}

resource "aws_autoscaling_group" "webserver" {
  name                = "${var.namespace}-asg"
  min_size            = 1
  max_size            = 3
  vpc_zone_identifier = var.vpc.private_subnets
  target_group_arns   = module.alb.target_group_arns
  launch_template {
    id = aws_launch_template.webserver.id
  }
}

module "alb" {
  source                   = "scottwinkler/alb/aws"
  load_balancer_name       = "${var.namespace}-alb"
  security_groups          = [var.sg.lb]
  subnets                  = var.vpc.public_subnets
  vpc_id                   = var.vpc.vpc_id
  logging_enabled          = false
  http_tcp_listeners       = [{ port = 80, protocol = "HTTP" }]
  http_tcp_listeners_count = "1"
  target_groups            = [{ name = "websvr", backend_protocol = "HTTP", backend_port = 8080 }]
  target_groups_count      = "1"
}
