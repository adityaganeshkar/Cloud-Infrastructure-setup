#!/bin/bash
sudo yum update && sudo yum upgrade -y
sudo yum install nginx -y
sudo yum install java-17-amazon-corretto-devel -y
cd /opt
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-4.noarch.rpm
sudo dnf install mysql80-community-release-el9-4.noarch.rpm -y
sudo dnf update
dnf repolist enabled
sudo dnf install mysql-community-server -y
sudo systemctl start mysqld
sudo sed -i '/\[mysqld\]/a bind-address=0.0.0.0' /etc/my.cnf
sudo systemctl restart mysqld
sleep 5
root_password=$(sudo grep 'password' /var/log/mysqld.log | awk '{print $NF}')
mysql --connect-expired-password -u root -p"$root_password" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE DATABASE dullhuke;
CREATE USER 'kum'@'%' IDENTIFIED WITH mysql_native_password BY 'Admin@123';
GRANT ALL PRIVILEGES ON *.* TO 'kum'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;"





