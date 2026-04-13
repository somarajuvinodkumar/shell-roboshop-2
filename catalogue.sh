#!/bin/bash

source ./common.sh
app_name=catalogue

check_root

app_setup
nodejs_setup
systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
dnf install mongodb-mongosh -y
VALIDATE $? "Installing mongdb client"

STATUS=$(mongosh --host mongodb.somaraju.online. --eval 'db.getMongo().getDBnames().indexof("catalogue")')
if [ STATUS -lt 0 ]
then 
     mongosh --host mongodb.somaraju.online </app/db/master-data.js &>>$LOG_FILE 
     VALIDATE $? "Loading data into mongodb"
else
    echo -e "Data is already loaded ...$Y SKIPPING $N"
fi
