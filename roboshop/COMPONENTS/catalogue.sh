source COMPONENTS/common.sh
yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
STAT_CHECK $? "Install nodejs"
id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG_FILE}
  STAT_CHECK $? "User Add"
fi
Download catalogue
STAT_CHECK $? "Download Catalogue"
#$ mv catalogue-main catalogue
#$ cd /home/roboshop/catalogue
#$ npm install
#NOTE: We need to update the IP address of MONGODB Server in systemd.service file
#Now, lets set up the service with systemctl.
#
## mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
## systemctl daemon-reload
## systemctl start catalogue
## systemctl enable catalogue