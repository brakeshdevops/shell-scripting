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

rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
STAT_CHECK $? "Added roboshop user"

## rabbitmqctl set_user_tags roboshop administrator
## rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
