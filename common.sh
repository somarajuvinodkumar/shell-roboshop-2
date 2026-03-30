#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

check_root(){
    
# check the user has root priveleges or not
if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access" | tee -a $LOG_FILE
fi
}


VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}


print_time(){
    
START_TIME=$(date +%s)   
END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE
}

nodejs_setup(){

  dnf module disable nodejs -y &>>$LOG_FILE
  VALIDATE $? "disabling nodejs"

  dnf module enable nodejs:20 -y &>>$LOG_FILE
  VALIDATE $? "enabling nodejs"

  dnf install nodejs -y &>>$LOG_FILE

  npm install &>>$LOG_FILE

}

app_setup(){

   id roboshop 
   if [ $? -ne 0 ]
   then
       useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
   else
        echo -e "system user roboshop already created ...$Y SKIPPING $N" 
   fi
    
   mkdir -p /app 

   curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE

    rm -rf /app/*
    cd /app 
    unzip /tmp/$app_name.zip &>>$LOG_FILE

}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOG_FILE

    systemctl daemon-reload &>>$LOG_FILE
    systemctl enable $app_name
    systemctl start $app_name
}
    






