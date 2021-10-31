provider "aws" {
  region     = "us-west-2"
  access_key = "xxxxxxxxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

}
locals {
  environment = "webserver"
}
resource "aws_instance" "sample" {
  count         = var.counters == false ? 3 : 0
  ami           = "ami-013a129d325529d4d"
  instance_type = "t2.micro"
  tags = {
    Name = local.environment
  }
}