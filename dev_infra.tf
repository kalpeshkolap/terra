provider "aws" {
    region     = "xxxxxxxxxx"
    access_key = "xxxxxxxxxxxxxxxxxx"
    secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    }

resource "aws_vpc" "dev-infra" {
    cidr_block           = "192.168.0.0/24"
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
}


resource "aws_security_group" "web-security"{
    name        = "webserver"
    description = "security"
    vpc_id      = aws_vpc.dev-infra.id
    dynamic "ingress" {
        for_each = var.security-web      
        content {
            description = ingress.value.description
            from_port   = ingress.value.port
            to_port     = ingress.value.port
            protocol    = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
        }
    }

    egress  {
        from_port   = 0  
        to_port     = 0 
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    
    }
    tags = {
        Name = "Web-security_group"
    }
}

resource "aws_security_group" "db-security"{
    name        = "database"
    description = "security"
    vpc_id      = aws_vpc.dev-infra.id
    dynamic "ingress" {
        for_each = var.security-db     
        content {
            description  = ingress.value.description
            from_port    = ingress.value.port
            to_port      = ingress.value.port
            protocol     = ingress.value.protocol
            cidr_blocks  = ingress.value.cidr_blocks
        }
    }

    dynamic "egress"  {
        for_each = var.security-db     
        content {
            description  = egress.value.description
            from_port    = egress.value.port
            to_port      = egress.value.port
            protocol     = egress.value.protocol
            cidr_blocks  = egress.value.cidr_blocks
        }
    
    }
    tags = {
        Name = "Database-security-group"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.dev-infra.id
    tags   = {
        Name = "dev-igw"
    }
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.dev-infra.id
    route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.igw.id
        }
    tags  = {
        Name = "public-route"
    }

}

resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.dev-subnet[0].id
    route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "dev-subnet" {
    vpc_id = aws_vpc.dev-infra.id
    for_each                = var.subnet
    map_public_ip_on_launch =  each.value["map_public_ip_on_launch"]
    cidr_block              = each.value["cidr_block"]
    availability_zone       = "us-west-2a"
    tags = {
        Name = each.value["tags"]
    }
}

resource "aws_instance" "pub" {
    subnet_id       = aws_subnet.dev-subnet[0].id
    for_each        = var.instance
    ami             = each.value["ami"]
    instance_type   = each.value["instance_type"]
    key_name = "ub"
    user_data = file("web.sh")
    security_groups = ["${aws_security_group.web-security.id}"]
    lifecycle {
        create_before_destroy = true
      }
    tags = {
        Name = "webserver"
    }
}

resource "aws_instance" "pri" {
    subnet_id       = aws_subnet.dev-subnet[1].id
    for_each        = var.instance
    ami             = each.value["ami"]
    instance_type   = each.value["instance_type"]
    key_name = "ub"
    user_data = file("database.sh")
    security_groups = ["${aws_security_group.db-security.id}"]
    lifecycle {
        create_before_destroy = true
    }
    tags = {
        Name = "dbserver"
    }
}
