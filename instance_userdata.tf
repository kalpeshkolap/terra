provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_instance" "linux" {
    ami = "${var.ami}"
    instance_type = "${var.instanceType}"
    key_name = "ub"
    user_data = <<-EOF
                    #! /bin/bash
                    sudo yum update -y
                    sudo yum install httpd -y     
                    sudo systemctl start httpd
                    sudo systemctl enable httpd
                    sudo echo "welcome" > /var/www/html/index.html
                    sudo systemctl restart httpd
                    EOF
}

