source COMPONENTS/common.sh
yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
STAT_CHECK $? "Install nodejs"
id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG_FILE}
  STAT_CHECK $? "User Add"
fi
Download catalogue
rm -rf /home/roboshop/catalogue && mkdir -p /home/roboshop/catalogue && cp -r /tmp/catalogue-main/* /home/roboshop/catalogue &>>${LOG_FILE}
STAT_CHECK $? "Copy catalogue content"
cd /home/roboshop/catalogue && npm install --unsafe-perm &>>${LOG_FILE}
STAT_CHECK $? "Install npm"
chown roboshop:roboshop -R /home/roboshop
sed -i -e 's/MONGO_DNSNAME/mongod.roboshop.internal' /home/roboshop/catalogue/systemd.service && mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
STAT_CHECK $? "update systemd file"

#NOTE: We need to update the IP address of MONGODB Server in systemd.service file
#Now, lets set up the service with systemctl.
#
## mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
## systemctl daemon-reload
## systemctl start catalogue
## systemctl enable catalogue