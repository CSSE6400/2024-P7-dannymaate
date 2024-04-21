locals {  
   image = "${aws_ecr_repository.taskoverflow.repository_url}:latest"
   database_username = "administrator" 
   database_password = "foobarbaz" # this is bad 
}