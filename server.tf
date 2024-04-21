resource "aws_ecs_cluster" "taskoverflow" { 
   name = "taskoverflow" 
}

resource "aws_ecs_task_definition" "taskoverflow" { 
   family = "taskoverflow" 
   network_mode = "awsvpc" 
   requires_compatibilities = ["FARGATE"] 
   cpu = 1024 
   memory = 2048 
   execution_role_arn = data.aws_iam_role.lab.arn 
 
   container_definitions = <<DEFINITION
 [ 
   { 
    "image": "${local.image}", 
    "cpu": 1024, 
    "memory": 2048, 
    "name": "todo", 
    "networkMode": "awsvpc", 
    "portMappings": [ 
      { 
       "containerPort": 6400, 
       "hostPort": 6400 
      } 
    ], 
    "environment": [ 
      { 
       "name": "SQLALCHEMY_DATABASE_URI", 
       "value": "postgresql://${local.database_username}:${local.database_password}@${aws_db_instance.taskoverflow_database.address}:${aws_db_instance.taskoverflow_database.port}/${aws_db_instance.taskoverflow_database.db_name}" 
      } 
    ], 
    "logConfiguration": { 
      "logDriver": "awslogs", 
      "options": { 
       "awslogs-group": "/taskoverflow/todo", 
       "awslogs-region": "us-east-1", 
       "awslogs-stream-prefix": "ecs", 
       "awslogs-create-group": "true" 
      } 
    } 
   } 
 ] 
 DEFINITION
}

resource "aws_ecs_service" "taskoverflow" { 
   name = "taskoverflow" 
   cluster = aws_ecs_cluster.taskoverflow.id 
   task_definition = aws_ecs_task_definition.taskoverflow.arn 
   desired_count = 1 
   launch_type = "FARGATE" 
 
   network_configuration { 
    subnets = data.aws_subnets.private.ids 
    security_groups = [aws_security_group.taskoverflow.id] 
    assign_public_ip = true 
   } 
}

resource "aws_ecr_repository" "taskoverflow" { 
 name = "taskoverflow" 
}

resource "docker_image" "taskoverflow" { 
 name = "${aws_ecr_repository.taskoverflow.repository_url}:latest" 
 build { 
   context = "." 
 } 
} 
 
resource "docker_registry_image" "taskoverflow" { 
 name = docker_image.taskoverflow.name 
}