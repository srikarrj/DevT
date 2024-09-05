resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-cluster"

  # ... Add other cluster configuration options (if needed)
}

# Create a Fargate task definition
resource "aws_ecs_task_definition" "medusa_task" {
  # ... Define your task definition here
}

# Create an ECS service
resource "aws_ecs_service" "medusa_service" {
  name = "medusa-service"
  cluster = aws_ecs_cluster.medusa_cluster.name
  task_definition = aws_ecs_task_definition.medusa_task.arn
  desired_count = 1
  launch_type = "FARGATE"
}

# Create a load balancer (optional) as shown in the previous response
# ... (load balancer configuration)
