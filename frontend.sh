source common.sh

echo -e "${color}Installing Nginx${nocolor}"
dnf install nginx -y    &>>${logfile}

echo -e "${color}Remove default content${nocolor}"
rm -rf /usr/share/nginx/html/*    &>>${logfile}

echo -e "${color}Download and extract app content${nocolor}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip    &>>${logfile}
cd /usr/share/nginx/html
unzip /tmp/frontend.zip   &>>${logfile}

echo -e "${color}Setup Reverse proxy${nocolor}"
cp /home/centos/roboshop3-shell/frontend.conf /etc/nginx/default.d/roboshop.conf    &>>${logfile}

echo -e "${color}Start Nginx Server${nocolor}"
systemctl enable nginx    &>>${logfile}
systemctl restart nginx   &>>${logfile}