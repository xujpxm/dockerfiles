# Nginx的base image dockerfile

- 基于OpenResty制作而来
- 默认的NGINX_CONF路径：/usr/local/nginx/conf/nginx.conf
- Nginx Metric Lib的路径：/usr/local/nginx/nginx-lua-prometheus
- 日志切割脚本路径：/data/scripts/nginx_log.sh
- 定时任务文件：/etc/cron.d/nginx.cron
