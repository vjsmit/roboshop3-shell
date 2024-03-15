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
  id roboshop
  if [ $? -ne 0 ]; then
    useradd roboshop
  fi

  echo -e "${color}Create App Dir${nocolor}"
  rm -rf /app
  mkdir /app

  echo -e "${color}Download App content${nocolor}"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  echo -e "${color}Unzip App content${nocolor}"
  cd /app
  unzip /tmp/${component}.zip

}

func_systemd_setup() {
  echo -e "${color}Setup ${component} service${nocolor}"
  cp /home/centos/roboshop3-shell/${component}.service /etc/systemd/system/${component}.service

  echo -e "${color}Start ${component} Service${nocolor}"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

}

func_nodejs() {
  echo -e "${color}Enable Nodejs18${nocolor}"
  dnf module disable nodejs -y    &>>{logfile}
  dnf module enable nodejs:18 -y    &>>{logfile}
  
  echo -e "${color}Install Nodejs${nocolor}"
  dnf install nodejs -y   &>>{logfile}
  
  func_app_presetup

  echo -e "${color}Download App Dependencies${nocolor}"
  npm install   &>>{logfile}
  
  func_systemd_setup
}

func_schema() {
  echo -e "${color}Install Mongodb client${nocolor}"
  dnf install mongodb-org-shell -y    &>>{logfile}

  echo -e "${color}Load Schema${nocolor}"
  mongo --host mongodb-dev.smitdevops.online </app/schema/catalogue.js    &>>{logfile}

}