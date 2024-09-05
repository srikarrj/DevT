# Configure AWS provider
provider "aws" {
  region = "us-east-1" 
}

# Create an ECS cluster
resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-cluster"
}

# Create a Fargate task definition
resource "aws_ecs_task_definition" "medusa_task" {
  family = "medusa-task"

  container_definitions = [
    {
      name = "medusa"
      image = "medusa-commerce/medusa:latest" 
      port_mappings = [
        {
          container_port = 8000
          host_port = 80
          protocol = "tcp"
        }
      ]
    }
  ]
}

# Create an ECS service
resource "aws_ecs_service" "medusa_service" {
  name = "medusa-service"
  cluster = aws_ecs_cluster.medusa_cluster.name
  task_definition = aws_ecs_task_definition.medusa_task.arn
  desired_count = 1
  launch_type = "FARGATE"
}

# Create a load balancer (optional)
resource "aws_lb" "medusa_lb" {
  name = "medusa-lb"
  subnets = ["vpc-066657342c3ad09a0", "vpc-066657342c3ad09a0"] 
  security_groups = ["sg-0924a4b2e1c615373"] 
}

resource "aws_lb_target_group" "medusa_target_group" {
  name = "medusa-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = vpc-066657342c3ad09a0
}

resource "aws_lb_target_group_attachment" "medusa_target_group_attachment" {
  target_group_arn = aws_lb_target_group.medusa_target_group.arn
  target_id = aws_ecs_service.medusa_service.task_definition
}
