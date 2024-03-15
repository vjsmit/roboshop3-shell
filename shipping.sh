source common.sh
component=shipping

mysql_pwd=$1

if [ -z "${mysql_pwd}" ]; then
    echo Please enter mysql pwd
    exit 1
fi

func_maven