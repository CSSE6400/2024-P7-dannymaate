resource "aws_security_group" "taskoverflow_database" { 
 name = "taskoverflow_database" 
 description = "Allow inbound Postgresql traffic" 
 
 ingress { 
   from_port = 5432 
   to_port = 5432 
   protocol = "tcp" 
   cidr_blocks = ["0.0.0.0/0"] 
 } 
 
 egress { 
   from_port = 0 
   to_port = 0 
   protocol = "-1" 
   cidr_blocks = ["0.0.0.0/0"] 
   ipv6_cidr_blocks = ["::/0"] 
 } 
 
 tags = { 
   Name = "taskoverflow_database" 
 } 
}

resource "aws_security_group" "taskoverflow" { 
   name = "taskoverflow" 
   description = "TaskOverflow Security Group" 
 
   ingress { 
    from_port = 6400 
    to_port = 6400 
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
   } 
 
   ingress { 
    from_port = 22 
    to_port = 22 
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
   } 
 
   egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
   } 
}

data "aws_ecr_authorization_token" "ecr_token" {} 
 
provider "docker" { 
 registry_auth { 
   address = data.aws_ecr_authorization_token.ecr_token.proxy_endpoint 
   username = data.aws_ecr_authorization_token.ecr_token.user_name 
   password = data.aws_ecr_authorization_token.ecr_token.password 
 } 
}