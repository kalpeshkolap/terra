provider "aws" {
    region     = "xxxxxxxxxxx"
    access_key = "xxxxxxxxxxxxxxxxxx"
    secret_key = "xxxxxxxxxxxxxxxxxxxxxx"

}

resource "aws_vpc" "my-vpc" {
    cidr_block       = "192.168.0.0/24"
    instance_tenancy = "default"
    tags = {
        Name = "my-vpc"
    }

}

resource "aws_subnet" "my-sub" {
    vpc_id     = aws_vpc.my-vpc.id
    map_public_ip_on_launch = true
    cidr_block = "192.168.0.0/24"
    tags = {
        Name = "my-sub"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "my-igw"
    }
}

resource "aws_route_table" "myroute" {
    vpc_id = aws_vpc.my-vpc.id

    route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.igw.id
        }
    tags = {
        Name = "my-route"
    }

}


resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.my-sub.id

    route_table_id = aws_route_table.myroute.id
}

