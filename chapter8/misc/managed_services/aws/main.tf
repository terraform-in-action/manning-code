resource "random_string" "rand" {
  length  = 24
  special = false
  upper   = false
}

locals {
  namespace = substr(join("-", [var.namespace, random_string.rand.result]), 0, 24)
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
  version                      = "2.15.0"
  name                         = "${local.namespace}-vpc"
  cidr                         = "10.0.0.0/16"
  azs                          = data.aws_availability_zones.available.names
  private_subnets              = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets               = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
}

# ALB Security group
module "alb_sg" {
  source = "scottwinkler/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [{
    port        = 80
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

module "websvr_sg" {
  source = "scottwinkler/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port            = var.app.port
      security_groups = [module.alb_sg.security_group.id]
    }
  ]
}

resource "aws_lb" "lb" {
  name            = "${local.namespace}-lb"
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_sg.security_group.id]
}

resource "aws_lb_target_group" "lb_target_group" {
  depends_on  = [aws_lb.lb]
  name        = "${local.namespace}-group"
  port        = var.app.port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group.id
    type             = "forward"
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.namespace}-ecs-cluster"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/ecs/${local.namespace}-app"
}

data "aws_region" "current" {}

#------------------------------------------------------------------------------
# IAM Role & Policy for COP Service
#------------------------------------------------------------------------------

data "aws_iam_policy_document" "task_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "logs:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "task_iam_policy" {
  name   = "${local.namespace}-task-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.task_iam_policy_document.json
}


data "aws_iam_policy_document" "iam_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_role" {
  name               = "${local.namespace}-task-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.iam_role_policy_document.json
}

resource "aws_iam_policy_attachment" "task_iam_policy_role_attachment" {
  name       = "${local.namespace}-task-policy-attachment"
  roles      = [aws_iam_role.task_role.name]
  policy_arn = aws_iam_policy.task_iam_policy.arn
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  depends_on               = [aws_iam_policy_attachment.task_iam_policy_role_attachment]
  family                   = "${local.namespace}-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  container_definitions    = <<DEFINITION
[
  {
    "cpu": 256,
    "image": "${var.app.image}",
    "entryPoint": ["/bin/bash","-c","${var.app.command}"],
    "essential": true,
    "memory": 512,
    "name": "${local.namespace}-app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.app.port},
        "hostPort": ${var.app.port}
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.log_group.name}",
          "awslogs-region": "${data.aws_region.current.name}",
          "awslogs-stream-prefix": "ecs"
        }
    }
  }
]
DEFINITION
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${local.namespace}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [module.websvr_sg.security_group.id]
    subnets         = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "${local.namespace}-app"
    container_port   = var.app.port
  }
}
