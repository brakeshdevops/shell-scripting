source COMPONENTS/common.sh
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}
STAT_CHECK $? "download mongodb repository"
yum install -y mongodb-org &>>${LOG_FILE}
STAT_CHECK $? "Install Mongodb"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG_FILE}
STAT_CHECK $? "Update mongodb configuration file"

systemctl enable mongod &>>${LOG_FILE} && systemctl restart mongod &>>${LOG_FILE}
STAT_CHECK $? "Started mongodb service"

Download mongodb

cd mongodb-main
mongo < catalogue.js &>>${LOG_FILE} && mongo < users.js &>>${LOG_FILE}
STAT_CHECK $? "Loading the schema"

curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
STAT_CHECK $? "Downloaded redis"

yum install redis -y &>>${LOG_FILE}
STAT_CHECK $? "Installed redis"

sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/redis.conf &>>${LOG_FILE}
STAT_CHECK $? "Update IP address"

systemctl enable redis &>>${LOG_FILE} && systemctl restart redis &>>${LOG_FILE}
STAT_CHECK $? "Start redis database"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG_FILE}
STAT_CHECK $? "Download RabbitMQ Repository"

yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG_FILE}
STAT_CHECK $? "Install erlang and RabbitMQ"

systemctl enable rabbitmq-server &>>${LOG_FILE} && systemctl restart rabbitmq-server &>>${LOG_FILE}
STAT_CHECK $? "Enable and start RabbitMQ server "
rabbitmqctl list_users|grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
  STAT_CHECK $? "Added roboshop user"
fi
rabbitmqctl set_user_tags roboshop administrator &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG_FILE}
STAT_CHECK $? "Setup RabbitMQ permissions"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
STAT_CHECK $? "Downloading the mysql repository"

yum install mysql-community-server -y &>>${LOG_FILE}
STAT_CHECK $? "Installing mysql server"

systemctl enable mysqld &>>${LOG_FILE} &&systemctl start mysqld &>>${LOG_FILE}
STAT_CHECK $? "Staring mysql server"

default_pwd=$($ sudo grep 'temporary password' /var/log/mysqld.log|awk '{print $NF}')

echo"ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';" >/tmp/pass.sql
mysql --connect-expired-password -uroot -p"${default_pwd}" </tmp/pass.sql &>>${LOG_FILE}
STAT_CHECK $? "Password Setup"
#
#Now a default root password will be generated and given in the log file.
## grep temp /var/log/mysqld.log
#
#Next, We need to change the default root password in order to start using the database service.
## mysql_secure_installation
#
#You can check the new password working or not using the following command.
#
## mysql -u root -p
#
#Run the following SQL commands to remove the password policy.
#> uninstall plugin validate_password;
#Setup Needed for Application.
#As per the architecture diagram, MySQL is needed by
#
#Shipping Service
#So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
#To download schema, Use the following command
#
## curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#Load the schema for Services.
#
## cd /tmp
## unzip mysql.zip
## cd mysql-main
## mysql -u root -pRoboShop@1 <shipping.sql