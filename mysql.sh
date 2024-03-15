source common.sh

echo -e "${color}Disable Mysql8${nocolor}"
dnf module disable mysql -y

echo -e "${color}Setup the MySQL5.7 repo file${nocolor}"
cp /home/centos/roboshop3-shell/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "${color}Install MySQL Server${nocolor}"
dnf install mysql-community-server -y

echo -e "${color}Start MySQL Service${nocolor}"
systemctl enable mysqld
systemctl restart mysqld

echo -e "${color}Change default pwd${nocolor}"
mysql_secure_installation --set-root-pass RoboShop@1