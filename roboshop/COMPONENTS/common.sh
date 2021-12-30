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
set-hostname -skip-apply ${COMPONENT}
Download()
{
  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip" &>>${LOG_FILE}
  STAT_CHECK $? "Downloading ${1} file"
  cd /tmp
  unzip -o ${1}.zip &>>${LOG_FILE}
  STAT_CHECK $? "Unzipping the file"
}
nodejs()
{
  yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
  STAT_CHECK $? "Install nodejs"
  id roboshop &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${LOG_FILE}
    STAT_CHECK $? "User Add"
  fi
  Download ${1}
  rm -rf /home/roboshop/${1} && mkdir -p /home/roboshop/${1} && cp -r /tmp/${1}-main/* /home/roboshop/${1} &>>${LOG_FILE}
  STAT_CHECK $? "Copy ${1} content"
  cd /home/roboshop/${1} && npm install --unsafe-perm &>>${LOG_FILE}
  STAT_CHECK $? "Install npm"
  chown roboshop:roboshop -R /home/roboshop
  sed -i -e 's/MONGO_DNSNAME/mongod.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongod.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/${1}/systemd.service &>>${LOG_FILE} && mv /home/roboshop/${1}/systemd.service /etc/systemd/system/${1}.service &>>${LOG_FILE}
  STAT_CHECK $? "update systemd file"
  systemctl daemon-reload &>>${LOG_FILE} && systemctl start ${1} &>>${LOG_FILE} && systemctl enable ${1} &>>${LOG_FILE}
  STAT_CHECK $? "Restart ${1}"
}