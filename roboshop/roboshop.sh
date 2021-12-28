#!/bin/bash
# yum install nginx -y
# systemctl enable nginx
# systemctl start nginx
user_id=$(id -u)
if [ ${user_id} -ne 0 ]; then
  echo "you are not a root user"
  exit
fi
export COMPONENT=$1
if [ -z "$COMPONENT" ]; then
  echo "Component input missing"
  exit
fi

if [ ! -e COMPONENTS/${COMPONENT}.sh ]; then
  echo -e "\e[1;31m Component missing\e[0m"
  exit
fi
bash COMPONENTS/${COMPONENT}.sh
