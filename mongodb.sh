#!/bin/bash

source ./common.sh
app_name=mongodb

check_root

print_time

cp mongo.repo /etc/yum.repos.d/mongodbb.repo
VALIDATE $? "copying mongodb repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "installing mongodb server"

systemctl enable mongodb &>>$LOG_FILE
VALIDATE $? "enabling mongodb"

systemctl start mongodb &>>$LOG_FILE
VALIDATE $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "editing mongodb conf files for remote connections"

systemctl restart mongodb &>>$LOG_FILE
VALIDATE $? "restarting mongodb"
