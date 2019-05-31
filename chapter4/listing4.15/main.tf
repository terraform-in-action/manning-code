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
