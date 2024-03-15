color="\e[33m"
nocolor="\e[0m"

logfile="/tmp/roboshop.log"

user_id=$(id -u)

if [ ${user_id} -ne 0 ]; then
    echo "Login as a root user, exiting script"
    exit 1
fi

func_app_presetup() {
  echo -e "${color}Add App User${nocolor}"
  id roboshop   &>>{logfile}
  if [ $? -ne 0 ]; then
    useradd roboshop    &>>${logfile}
  fi

  echo -e "${color}Create App Dir${nocolor}"
  rm -rf /app
  mkdir /app

  echo -e "${color}Download App content${nocolor}"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip    &>>${logfile}

  echo -e "${color}Unzip App content${nocolor}"
  cd /app
  unzip /tmp/${component}.zip   &>>${logfile}

}

func_systemd_setup() {
  echo -e "${color}Setup ${component} service${nocolor}"
  cp /home/centos/roboshop3-shell/${component}.service /etc/systemd/system/${component}.service   &>>${logfile}

  sed -i -e "s/rabbitmq_pwd/${rabbitmq_pwd}/" /etc/systemd/system/${component}.service    &>>${logfile}

  echo -e "${color}Start ${component} Service${nocolor}"
  systemctl daemon-reload   &>>{logfile}
  systemctl enable ${component}   &>>${logfile}
  systemctl restart ${component}    &>>${logfile}

}

func_schema() {
  echo -e "${color}Setup Mongodb repo${nocolor}"
  cp /home/centos/roboshop3-shell/mongo.repo /etc/yum.repos.d/mongo.repo

  echo -e "${color}Install Mongodb client${nocolor}"
  dnf install mongodb-org-shell -y    &>>${logfile}

  echo -e "${color}Load Schema${nocolor}"
  mongo --host mongodb-dev.smitdevops.online </app/schema/catalogue.js    &>>${logfile}

}

func_mysql() {
  echo -e "${color}Install mysql client${nocolor}"
  dnf install mysql -y    &>>${logfile}

  echo -e "${color}Load Schema${nocolor}"
  mysql -h mysql-dev.smitdevops.online -uroot -p${mysql_pwd} </app/schema/shipping.sql    &>>${logfile}
}

func_nodejs() {
  echo -e "${color}Enable Nodejs18${nocolor}"
  dnf module disable nodejs -y    &>>${logfile}
  dnf module enable nodejs:18 -y    &>>${logfile}

  echo -e "${color}Install Nodejs${nocolor}"
  dnf install nodejs -y   &>>${logfile}

  func_app_presetup

  echo -e "${color}Download App Dependencies${nocolor}"
  npm install   &>>${logfile}

  func_systemd_setup
}

func_maven() {
  echo -e "${color}Install Maven${nocolor}"
  dnf install maven -y    &>>${logfile}

  func_app_presetup

  echo -e "${color}Download App Dependencies${nocolor}"
  mvn clean package   &>>${logfile}
  mv target/shipping-1.0.jar shipping.jar   &>>${logfile}

  func_mysql

  func_systemd_setup
}

func_python() {
  echo -e "${color}Install Python${nocolor}"
  dnf install python36 gcc python3-devel -y     &>>${logfile}

  func_app_presetup

  echo -e "${color}Install App Dependencies${nocolor}"
  pip3.6 install -r requirements.txt      &>>${logfile}

  func_systemd_setup
}

func_golang() {
  echo -e "${color}Install golang${nocolor}"
  dnf install golang -y   &>>{logfile}

  func_app_presetup

  echo -e "${color}Download App Dependencies${nocolor}"
  go mod init dispatch    &>>{logfile}
  go get    &>>{logfile}
  go build    &>>{logfile}

  func_systemd_Setup
}