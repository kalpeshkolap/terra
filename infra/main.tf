provider "aws" {
  region = "us-west-2"
}
#creating an aws instance
resource "aws_instance" "dev" {
  ami = "ami-013a129d325529d4d"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public[1].id
  key_name = "ub"
  user_data = file("web.sh")
  security_groups = [aws_security_group.web-security.id]
  tags = {
    Name = "webserver"
  }

}