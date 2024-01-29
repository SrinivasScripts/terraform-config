resource "aws_ecr_repository" "srini_ecr_repo" {
  name = "srini-repo"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "srini-tc"
}

resource "aws_ecs_task_definition" "app_td" {
  family                   = "srini-webapp-td"
  container_definitions    = <<DEFINITION
    [
        {
            "name": "srini-app,
            "image" : "${aws_ecr_repository.srini_ecr_repo.repository_url}",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": "${var.app_port}" ,
                    "hostPort": "${var.app_port}"
                }
            ],
            "cpu"                      =  "${var.fargate_cpu}" 
            "memory"                   = "${var.fargate_memory}" 
        }
    ]
    DEFINITION
  network_mode             = "awsvpc"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_task_execution_role_name
}


resource "aws_ecs_service" "main" {
  name            = "srini-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.app_td.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.security_group_id]
    subnets          = [var.ecs_private_subnet_id, var.ecs_private_subnet_id1]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_tg
    container_name   = "srini-app"
    container_port   = var.app_port
  }

  depends_on = [var.alb_listner, var.aws_iam_role_policy_attachment]
}
