STAT_CHECk()
{
  if [ $1 -ne 0 ]; then
    echo "$2"
    exit 1
  fi
}
yum install ngin -y
STAT_CHECK $? "Nginx installation failed"
systemctl enable nginx
systemctl start nginx
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
STAT_CHECK $? "Download frontend failed"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-master static README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
systemctl enable nginx
systemctl start nginx