#!/bin/bash
# yum install nginx -y
# systemctl enable nginx
# systemctl start nginx
uid=$(id -u)
if [ $(uid) -ne 0 ]; then
  echo "you are not a root user"
  exit
fi
yum install nginx -y
