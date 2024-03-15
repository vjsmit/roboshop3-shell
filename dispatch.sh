source common.sh
component=dispatch

rabbitmq_pwd=$1

if [ -z "$rabbitmq_pwd" ]; then
    echo Please enter rabbitmq pwd
    exit 1
fi

func_golang