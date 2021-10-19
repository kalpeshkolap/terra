

resource "aws_vpc" "my-vpc" {
    cidr_block =  "192.168.0.0/24"
    instance_tenancy =  "default"
    tags = {
    Name = "dev"
    }
}

resource "aws_subnet" "dev-subnet" {
    vpc_id = aws_vpc.my-vpc.id
    for_each = var.subnet
    map_public_ip_on_launch =  each.value["map_public_ip_on_launch"]
    cidr_block = each.value["cidr_block"]
    tags = {
        Name = each.value["tags"]
    }
}

resource "aws_instance" "pub" {
    subnet_id = aws_subnet.dev-subnet[1].id
    ami = "ami-013a129d325529d4d"
    instance_type = "t2.micro"
    key_name = "ub"
    tags = {
        Name = "testing_server"
    }
}