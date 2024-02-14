#!/bin/bash


sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo yum install update
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
sudo dnf install mysql-community-server -y
sudo dnf repolist enabed
sudo systemctl start mysqld
sudo vi /etc/my.cnf

sudo grep 'temporary password' /var/log/mysqld.log
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Aditya@123';
CREATE USER 'devop'@'%' IDENTIFIED WITH mysql_native_password BY 'Admin@123';
GRANT ALL PRIVILEGES ON *.* TO "devop"@"%" with grant option;
FLUSH PRIVILEGES;
\q
systemctl restart mysql





