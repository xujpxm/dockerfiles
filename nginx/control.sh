#!/usr/bin/env bash

NGINX_CONF=/usr/local/nginx/conf/nginx.conf

# start cmd
start() {
    echo "Start sshd..."
    /usr/sbin/sshd -f /home/work/.ssh/sshd_config

    echo "Start Nginx..."
    /usr/local/nginx/sbin/nginx -t -c ${NGINX_CONF}
    /usr/local/nginx/sbin/nginx -c ${NGINX_CONF} -g "daemon off;"
}

# quit: Gracefully shutdown Nginx (wait for workers to finish their tasks)
quit() {
    echo "Quit Nginx..."
    /usr/local/nginx/sbin/nginx -c ${NGINX_CONF} -s quit
}

# stop: Immediately shutdown Nginx
stop() {
    echo "Stop Nginx..."
    /usr/local/nginx/sbin/nginx -c ${NGINX_CONF} -s stop
}

# Reload Nginx 
reload() {
    echo "Reload Nginx..."
    /usr/local/nginx/sbin/nginx -c ${NGINX_CONF} -s reload && echo "Reload Nginx Configuration Successfully!"
}

# Show version and configure options
version() {
    echo "Nginx version:"
    /usr/local/nginx/sbin/nginx -V
}

# Nginx conf test
test() {
    /usr/local/nginx/sbin/nginx -c ${NGINX_CONF} -t
}

# Quit Nginx and clean up
quitcleanup() {
    echo "SIGQUIT received. Performing quit..."
    quit
    exit 0
}

# Stop Nginx and clean up
stopcleanup() {
    echo "SIGTERM received. Performing stop..."
    stop
    exit 0
}

trap quitcleanup SIGQUIT SIGINT
trap stopcleanup SIGTERM

# 执行启动命令
if [ $# -eq 0 ] || [ "$1" = "start" ];then
    start
elif [ "$1" = "quit" ];then
    quit
elif [ "$1" = "stop" ];then
    stop
elif [ "$1" = "reload" ];then
    reload
elif [ "$1" = "version" ];then
    version 
elif [ "$1" = "test" ];then
   test
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 [start|quit|stop|reload|version|test|-h|--help]"
    echo
    echo "Commands:"
    echo "  start       Start Nginx."
    echo "  quit        Gracefully shutdown Nginx."
    echo "  stop        Immediately shutdown Nginx."
    echo "  reload      Reload Nginx configuration."
    echo "  version     Show Nginx version and configure options."
    echo "  test        Test Nginx configuration and exit."
    echo "  -h, --help  Show this help message."
else
    echo "Error,Invalid Argument,use -h/--help to show avaliable command."
fi

