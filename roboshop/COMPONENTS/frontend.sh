source COMPONENTS/common.sh
yum install nginx -y &>>${LOG_FILE}
STAT_CHECK $? "Nginx installation"

Download frontend
rm -rf /usr/share/nginx/html/*
STAT_CHECK $? "Remove old html files"
cd /tmp && unzip -o /tmp/frontend.zip &>>${LOG_FILE}
STAT_CHECK $? "Extracting Frontend content"
cd /tmp/frontend-main/static/ && cp -r * /usr/share/nginx/html/
STAT_CHECK $? "copying front end content"
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT_CHECK $? "Updating nginx config file"
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
systemctl enable nginx &>>${LOG_FILE} && systemctl restart nginx &>>${LOG_FILE}
STAT_CHECK $? "Restart nginx"