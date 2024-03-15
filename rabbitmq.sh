echo -e "${}Setup Erlang repo${}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "${}Setup RabbitMQ repo${}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "${}Install Rabbitmq${}"
dnf install rabbitmq-server -y

echo -e "${}Start RabbitMQ Service${}"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "${}Create user for the app${}"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"