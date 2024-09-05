resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-ecs-cluster"
}

resource "aws_ecs_task_definition" "medusa_task" {
  family                = "medusa-task-definition"
  cpu                   = 256
  memory                = 512
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name      = "medusa-container"
      image     = "medusajs/medusa:latest"
      portMappings = [
        {
          containerPort = 9000
          hostPort      = 9000
        }
      ]
      environment = [
        {
          name  = "MEDUSA_DB_USERNAME"
          value = "<db_username>"
        },
        {
          name  = "MEDUSA_DB_PASSWORD"
          value = "<db_password>"
        },
        {
          name  = "MEDUSA_DB_HOST"
          value = "<db_host>"
        },
        {
          name  = "MEDUSA_DB_PORT"
          value = "<db_port>"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.name
  task_definition = aws_ecs_task_definition.medusa_task.arn
  launch_type      = "FARGATE"
  network_configuration {
    awsvpc_configuration {
      subnets          = ["<subnet_id>"]
      security_groups = ["<security_group_id>"]
      assign_public_ip = "ENABLED"
    }
  }
}

