color="\e[33m"
nocolor="\e[0m"

logfile="/tmp/roboshop.log"

user_id=$(id -u)

if [ ${user_id} -ne 0 ]; then
    echo "Login as a root user, exitinf script"
    exit 1
fi