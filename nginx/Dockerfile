FROM centos:7.9

ENV NGINX_CONF=/usr/local/nginx/conf/nginx.conf

COPY openresty-bin-1.25.tar.gz /tmp/openresty.tar.gz

RUN yum -y install openssh-server unzip luajit crontabs git wget net-tools \
    && tar -zxf /tmp/openresty.tar.gz -C /usr/local/ \
    && /usr/sbin/groupadd nginx \
    && /usr/sbin/useradd -g nginx nginx -s /sbin/nologin -M \
    && mkdir -p /data/nginx/logs \
    && wget -c https://github.com/knyar/nginx-lua-prometheus/archive/refs/tags/0.20240525.tar.gz -O /tmp/nginx-lua-prometheus.tar.gz \
    && tar -zxvf /tmp/nginx-lua-prometheus.tar.gz -C /usr/local/openresty/nginx/ \
    && ln -s /usr/local/openresty/nginx /usr/local/nginx \
    && chown -R work. /usr/local/openresty \
    && mkdir -p /home/work/.ssh \
    && chmod 0700 /home/work/.ssh \
    && ssh-keygen -N '' -t rsa -f /home/work/.ssh/ssh_host_rsa_key \
    && ssh-keygen -N '' -t ecdsa -f /home/work/.ssh_host_ecdsa_key \
    && ssh-keygen -N '' -t ed25519 -f /home/work/.ssh/ssh_host_ed25519_key \
    && sed -i '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond \
    && rm -f /tmp/*.tar.gz \
    && chmod 0600 /home/work/.ssh/authorized_keys \
    && chown -R work. /home/work/.ssh \
    && sed -i '/Port /aPort 3000' /home/work/.ssh/sshd_config \
    && rm -f /tmp/*.tar.gz \
    && rm -rf /var/cache/yum/

COPY control.sh      /home/work/control.sh
COPY authorized_keys /home/work/.ssh/authorized_keys 
COPY nginx_log.sh    /data/nginx/nginx_log.sh
COPY nginx.cron      /etc/cron.d/nginx.cron
COPY pod_sshd_config  /home/work/.ssh/sshd_config

RUN chmod +x /usr/local/openresty/nginx/control.sh \
    && chmod 0600 /home/work/.ssh/authorized_keys \
    && chown work. /home/work/.ssh/authorized_keys \
    && rm -rf /var/cache/yum/ 

STOPSIGNAL SIGQUIT

CMD ["/home/work/control.sh"]

