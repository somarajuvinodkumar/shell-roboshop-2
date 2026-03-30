#!/bin/bash

source ./common.sh

check_root

dnf module disable nginx -y &>>$LOG_FILE
VALIDATE $? "disabling nginx"

dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "enabling nginx"

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "installing nginx"

systemctl enable nginx
systemctl start nginx  &>>$LOG_FILE
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "removing default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "download frontend content"

cd /usr/share/nginx/html &>>$LOG_FILE
unzip /tmp/frontend.zip
VALIDATE $? "Extract the frontend content"

rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "Removing default ngoinx conf"

cp "$SCRIPT_DIR/nginx.conf" /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "copying nginx conf"

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "restarting nginx"

print_time