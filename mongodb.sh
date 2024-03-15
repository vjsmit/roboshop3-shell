source common.sh

echo -e "${color}Setup Mongodb Repo${nocolor}"
cp /home/centos/roboshop3-shell/mongo.repo /etc/yum.repos.d/mongo.repo    &>>${logfile}

echo -e "${color}Install Mongodb${nocolor}"
dnf install mongodb-org -y &>>${logfile}

echo -e "${color}Update listen address${nocolor}"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf   &>>${logfile}

echo -e "${color}Start Mongodb${nocolor}"
systemctl enable mongod   &>>${logfile}
systemctl restart mongod    &>>${logfile}