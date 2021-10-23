    #! /bin/bash
    sudo yum update -y
    sudo yum install mariadb-client mariadb-server -y     
    sudo systemctl start mariadb 
    sudo systemctl enable mariadb
    sudo systemctl reload mariadb
