source common.sh

mysql_pwd=$1
if [ -z "${mysql_pwd}" ]; then
    echo Please enter mysql pwd
    exit 1
fi

echo -e "${color}Disable Mysql8${nocolor}"
dnf module disable mysql -y   &>>${logfile}

echo -e "${color}Setup the MySQL5.7 repo file${nocolor}"
cp /home/centos/roboshop3-shell/mysql.repo /etc/yum.repos.d/mysql.repo    &>>${logfile}

echo -e "${color}Install MySQL Server${nocolor}"
dnf install mysql-community-server -y   &>>${logfile}

echo -e "${color}Start MySQL Service${nocolor}"
systemctl enable mysqld   &>>${logfile}
systemctl restart mysqld    &>>${logfile}

echo -e "${color}Change default pwd${nocolor}"
mysql_secure_installation --set-root-pass ${mysql_pwd}    &>>${logfile}