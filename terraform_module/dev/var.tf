variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "ami-id" {
  type    = string
  default = "ami-013a129d325529d4d"
}

variable "cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "counters" {
  type = number
  default = 3
}