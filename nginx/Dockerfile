FROM centos:7.9

ENV NGINX_CONF=/usr/local/nginx/conf/nginx.conf

COPY openresty-bin-1.25.tar.gz /tmp/openresty.tar.gz

RUN yum -y install openssh-server unzip luajit crontabs git wget net-tools \
    && tar -zxf /tmp/openresty.tar.gz -C /usr/local/ \
    && /usr/sbin/groupadd nginx \
    && /usr/sbin/useradd -g nginx nginx -s /sbin/nologin -M \
    && mkdir -pv {/data/nginx/logs,/root/.ssh,/data/scripts} \
    && wget -c https://github.com/knyar/nginx-lua-prometheus/archive/refs/tags/0.20240525.tar.gz -O /tmp/nginx-lua-prometheus.tar.gz \
    && tar -zxvf /tmp/nginx-lua-prometheus.tar.gz -C /usr/local/openresty/nginx/ \
    && ln -s /usr/local/openresty/nginx /usr/local/nginx \
    && chmod 0700 /root/.ssh \
    && sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config \
    && ssh-keygen -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key \
    && ssh-keygen -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key \
    && ssh-keygen -N '' -t ed25519 -f /etc/ssh/ssh_host_ed25519_key \
    && sed -i '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond \
    && rm -f /tmp/*.tar.gz \
    && chmod 0600 /root/.ssh/authorized_keys \
    && chmod u+s /usr/sbin/crond

COPY control.sh      /usr/local/openresty/nginx/control.sh
COPY authorized_keys /root/.ssh/authorized_keys 
COPY nginx_log.sh    /data/scripts/nginx_log.sh
COPY nginx.cron      /etc/cron.d/nginx.cron

RUN chmod +x /usr/local/openresty/nginx/control.sh \
    && chmod 0600 /root/.ssh/authorized_keys \
    && rm -rf /var/cache/yum/ 

CMD ["/usr/local/nginx/control.sh"]
