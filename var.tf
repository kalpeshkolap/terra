    variable "subnet" {
        description = "dev-subnet"
        type = map(object({
            map_public_ip_on_launch = bool
            cidr_block = string
            tags = string
        }))
    default = {
        0 = {
            map_public_ip_on_launch = true
            cidr_block = "192.168.0.0/25"
            tags = "public"
        },
        1 = {
            map_public_ip_on_launch = false
            cidr_block = "192.168.0.128/25"
            tags = "private"
        }
    }

    }


variable "instance" {
    description = "dev-instanse"
    type = map(object({
        ami = string
        instance_type = string
    }))
    default = {
        0 = {
            ami = "ami-013a129d325529d4d"
            instance_type = "t2.micro"
        }
    }
}

variable "security-web" {
    description = "Security_group_web"
    type = map(object({
        description = string
        port = number
        protocol = string
        cidr_blocks = list(string)
    }))
    default = {
        "22" = {
            description = "ssh-access"
            port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0",]
        }
        "80" = {
            description = "http-access"
            port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0",]
        }
        "3306" = {
            description = "ssh-access"
            port = 3306
            protocol = "tcp"
            cidr_blocks = ["192.168.0.128/25",]
        }
    }
}

variable "security-db" {
    description = "Security_group_dev"
    type = map(object({
        description = string
        port = number
        protocol = string
        cidr_blocks = list(string)
    }))
    default = {
        "database" = {
            description = "mysql-access"
            port = 80
            protocol = "tcp"
            cidr_blocks = ["192.168.0.0/25",]
        }
        "db" = {
            description = "ssh-access"
            port = 22
            protocol = "tcp"
            cidr_blocks = ["192.168.0.0/25",]
        }
    }

}
