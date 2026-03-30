#!/bin/bash
source ./common.sh
app_name=mongodb
 
check_root

cp mongo.repo /etc/yum.repos.d/mongodb.repo
VALIDATE $? "copying mongodb repo"

dnf install mongodb-org -y 
VALIDATE $? "installing mongodb server"

systemctl enable mongod 
VALIDATE $? "enabling mongod"

syatemctl start mongod 
VALIDATE $? "starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Editing mongodb conf file for remote connections"

systemctl restart mongod 
VALIDATE $? "restarting mongod"

print_name



