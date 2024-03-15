source common.sh
component=payment

rabbitmq_pwd=$1

if [ -z "$rabbitmq_pwd"  ]; then
    echo Please enter rabbitmq pwd
    exit 1
fi

func_python
