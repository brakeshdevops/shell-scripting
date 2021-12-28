LOG_FILE=/tmp/roboshop.log
rm -f ${LOG_FILE}
STAT_CHECK()
{
  if [ $1 -ne 0 ]; then
    echo -e "\e[1;31m$2-failed\e[0m"
    exit 1
  else
    echo -e "\e[1;32m$2-Success\e[0m"
  fi
}
yum install nginx -y &>>${LOG_FILE}
STAT_CHECK $? "Nginx installation"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}
STAT_CHECK $? "Download frontend"
rm -rf /usr/share/nginx/html/*
STAT_CHECK $? "Remove old html files"
cd /tmp && unzip /tmp/frontend.zip &>>${LOG_FILE}
STAT_CHECK $? "Extracting Frontend content"
cd /tmp/frontend-main/static/ && cp -r * /usr/share/nginx/html/
STAT_CHECK $? "copying front end content"
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT_CHECK $? "Updating nginx config file"
systemctl enable nginx &>>${LOG_FILE} && systemctl restart nginx &>>${LOG_FILE}
STAT_CHECK $? "Restart nginx"