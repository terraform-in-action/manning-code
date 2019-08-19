
module "iam_instance_profile" {
  source  = "scottwinkler/iip/aws"
  actions = ["logs:*", "ec2:DescribeInstances"]
}

locals {
  consul_config = templatefile("${path.module}/templates/consul_${var.consul.mode}.json", {
    instance_count = var.instance_count,
    namespace      = var.namespace,
  })
  nomad_config = templatefile("${path.module}/templates/nomad_${var.nomad.mode}.hcl", {
    instance_count = var.instance_count
  })
  startup = templatefile("${path.module}/templates/startup.sh", {
    consul_version = var.consul.version,
    consul_config  = local.consul_config,
    consul_mode    = var.consul.mode
    nomad_version  = var.nomad.version,
    nomad_config   = local.nomad_config,
    nomad_mode     = var.nomad.mode,
  })
  namespace = "${var.namespace}-${var.nomad.mode}-${var.consul.mode}"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_launch_template" "server" {
  name_prefix   = local.namespace
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = base64encode(local.startup)
  key_name      = var.ssh_keypair
  iam_instance_profile {
    name = module.iam_instance_profile.name
  }
  vpc_security_group_ids = [var.sg.server]
  tags = {
    ResourceGroup = var.namespace
  }
}

resource "aws_autoscaling_group" "server" {
  name                      = local.namespace
  health_check_grace_period = 3600
  default_cooldown          = 3600
  min_size                  = var.instance_count
  max_size                  = 3
  vpc_zone_identifier       = var.vpc.public_subnets
  //vpc_zone_identifier = var.vpc.private_subnets
  target_group_arns = var.target_group_arns
  launch_template {
    id      = aws_launch_template.server.id
    version = aws_launch_template.server.latest_version
  }
  tags = [
    {
      key                 = "ResourceGroup"
      value               = var.namespace
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = local.namespace
      propagate_at_launch = true
    },
    {
      key                 = "Nomad"
      value               = var.nomad.mode
      propagate_at_launch = true
    },
    {
      key                 = "Consul"
      value               = var.consul.mode
      propagate_at_launch = true
    }

  ]
}
