resource "aws_ecs_task_definition" "app" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory

  execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  task_role_arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"

  container_definitions = var.containers_definitions

  tags = {
    FargateApp = var.app_name
  }
}

resource "aws_ecs_service" "main" {
  name    = "${var.app_name}-svc"
  cluster = data.aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  platform_version = var.fargate_version

  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets         = split(",", join(",", data.aws_subnet_ids.private.ids))
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = var.app_name
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front_end]

}

# Traffic to the ECS Cluster should only come from the ALB

resource "aws_security_group" "ecs_tasks" {
  name        = "tf-ecs-${var.app_name}"
  description = "allow inbound access from the ALB only"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

