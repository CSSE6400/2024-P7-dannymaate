resource "aws_db_instance" "taskoverflow_database" { 
 allocated_storage = 20 
 max_allocated_storage = 1000 
 engine = "postgres" 
 engine_version = "14" 
 instance_class = "db.t4g.micro" 
 db_name = "todo"
 username = local.database_username 
 password = local.database_password 
 parameter_group_name = "default.postgres14" 
 skip_final_snapshot = true 
 vpc_security_group_ids = [aws_security_group.taskoverflow_database.id] 
 publicly_accessible = true 
 
 tags = { 
   Name = "taskoverflow_database" 
 } 
}
