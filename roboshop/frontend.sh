#!/bin/bash
# yum install nginx -y
# systemctl enable nginx
# systemctl start nginx
user_id=$(id -u)
if [ $(user_id) -ne 0 ]; then
  echo "you are not a root user"
  exit
fi
yum install nginx -y
