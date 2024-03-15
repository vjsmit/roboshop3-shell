echo -e "\e[33mInstalling Nginx\e[0m"
dnf install nginx -y

echo -e "\e[33mRemove default content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[33mDownload and extract app content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[33mSetup Reverse proxy\e[0m"
cp /home/centos/roboshop3-shell/frontend.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[33mStart Nginx Server\e[0m"
systemctl enable nginx
systemctl restart nginx