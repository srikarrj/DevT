resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.name
  task_definition = aws_ecs_task_definition.medusa_task.arn
  launch_type      = "FARGATE"
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 100
  }
  network_configuration {
    awsvpc_configuration {
      subnets          = ["<subnet-0d8556b1f3147578b>"]
      security_groups = ["<sg-0924a4b2e1c615373>"]
      assign_public_ip = "ENABLED"
    }
  }
}
