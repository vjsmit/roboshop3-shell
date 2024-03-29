source common.sh
rabbitmq_pwd=$1

if [ -z "$rabbitmq_pwd" ]; then
    echo Please enter rabbitmq pwd
    exit 1
fi

echo -e "${color}Setup Erlang repo${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash     &>>${logfile}

echo -e "${color}Setup RabbitMQ repo${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash    &>>${logfile}

echo -e "${color}Install Rabbitmq${nocolor}"
dnf install rabbitmq-server -y    &>>${logfile}

echo -e "${color}Start RabbitMQ Service${nocolor}"
systemctl enable rabbitmq-server    &>>${logfile}
systemctl restart rabbitmq-server   &>>${logfile}

echo -e "${color}Create user for the app${nocolor}"
rabbitmqctl add_user roboshop ${rabbitmq_pwd}   &>>${logfile}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"    &>>${logfile}