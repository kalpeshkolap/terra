resource "aws_vpc" "dev-vpc" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}
data "aws_availability_zones" "available" {}


resource "aws_subnet" "dev-subnet" {
  vpc_id                  = aws_vpc.dev-vpc.id
  count                   = var.counters
  cidr_block              = cidrsubnet(var.cidr, 2, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-${count.index}"
  }
}

resource "aws_instance" "dev-instance" {
  count         = var.counters
  ami           = var.ami-id
  instance_type = var.instance-type
  subnet_id     = aws_subnet.dev-subnet[count.index].id
  key_name      = "ub"
  tags = {
    Name = "dev-server-${count.index + 1}"
  }
}