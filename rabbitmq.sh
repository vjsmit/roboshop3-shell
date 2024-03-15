echo -e "${}Setup Erlang repo${}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash     &>>${logfile}

echo -e "${}Setup RabbitMQ repo${}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash    &>>${logfile}

echo -e "${}Install Rabbitmq${}"
dnf install rabbitmq-server -y    &>>${logfile}

echo -e "${}Start RabbitMQ Service${}"
systemctl enable rabbitmq-server    &>>${logfile}
systemctl restart rabbitmq-server   &>>${logfile}

echo -e "${}Create user for the app${}"
rabbitmqctl add_user roboshop roboshop123   &>>${logfile}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"    &>>${logfile}