resource "aws_security_group" "my-sec"{
    name = "testing_server_sec"
    description = "security"
    vpc_id = aws_vpc.my-vpc.id

    ingress  {
        description = "ssh_access"
        from_port = 22  
        to_port = 22 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "http_access"
        from_port = 80
        to_port = 80 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress  {
        from_port = 0  
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    
    }
    tags = {
        Name = "my-security_group"
    }
}

resource "aws_instance" "test" {
    subnet_id = aws_subnet.my-sub.id
    ami =  "ami-013a129d325529d4d"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.my-sec.id}"]
    key_name = "ub"
    tags = {
        Name = "testing_server"
    }

}