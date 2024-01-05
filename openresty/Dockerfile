# Dockerfile - CentOS 7 - RPM version
# https://github.com/xujpxm/dockerfiles/openresty

ARG RESTY_IMAGE_BASE="centos"
ARG RESTY_IMAGE_TAG="7.9.2009"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

ARG RESTY_IMAGE_BASE="centos"
ARG RESTY_IMAGE_TAG="centos7.4.1708"
ARG RESTY_PREFIX="/usr/local/openresty"
ARG RESTY_VERSION="1.21.4.3"
ARG NGX_VERSION="1.21.4"
ARG NGX_PROXY_CONNECT_VERSION="0.0.5"
ARG CONNECT_PATCH_VERSION="102101"
ARG NGX_UPS_CHECK_VERSION="0.4.0"
ARG UPS_CHECK_PATCH_VERSION="1.20.1+"
ARG RESTY_OPENSSL_VERSION="1.1.1k"
ARG RESTY_PCRE_VERSION="8.45"
ARG RESTY_J="1"
ARG RESTY_CONFIG_OPTIONS="\
    --prefix=/usr/local/openresty \
    --with-threads \
    --with-pcre-jit \
    --with-luajit \
    --with-cc-opt='-DTCP_FASTOPEN=23' \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-file-aio \
    --with-http_auth_request_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-stream \
    --with-stream_ssl_module \
    "

ARG RESTY_CONFIG_DEPS="\
    --with-openssl=/tmp/openssl-${RESTY_OPENSSL_VERSION} \
    --with-pcre=/tmp/pcre-${RESTY_PCRE_VERSION} \
    --add-module=/tmp/ngx_http_proxy_connect_module-${NGX_PROXY_CONNECT_VERSION} \
    --add-module=/tmp/nginx_upstream_check_module-${NGX_UPS_CHECK_VERSION} \
    "

LABEL resty_image_base="${RESTY_IMAGE_BASE}"
LABEL resty_image_tag="${RESTY_IMAGE_TAG}"
LABEL resty_version="${RESTY_VERSION}"
LABEL resty_openssl_version="${RESTY_OPENSSL_VERSION}"
LABEL resty_pcre_version="${RESTY_PCRE_VERSION}"
LABEL resty_prefix="${RESTY_PREFIX}"
LABEL ngx_proxy_connect_version="${NGX_PROXY_CONNECT_VERSION}"
LABEL ngx_ups_check_version="${NGX_UPS_CHECK_VERSION}"
LABEL connect_patch_version="${CONNECT_PATCH_VERSION}"

# 1) Install yum dependencies
# 2) Download Thirdparty Module and OpenResty
# 3) Build OpenResty
# 4) Cleanup

RUN yum install -y \
        perl \
        pcre-devel \
        dos2unix \
        openssl-devel \
        GeoIP-devel \
        gcc \
        gcc-c++ \
        make \
        gperftools-devel \
        gettext \
        gzip \
        unzip \
        tar \
        curl \
        wget \
        gettext \
        rsync \
        crontabs \
        snappy \
        mysql \
        git \
    && cd /tmp \
    && curl -fSL https://www.openssl.org/source/openssl-${RESTY_OPENSSL_VERSION}.tar.gz -o openssl-${RESTY_OPENSSL_VERSION}.tar.gz \
    && tar -zxvf openssl-${RESTY_OPENSSL_VERSION}.tar.gz \
    && curl -fSL https://sourceforge.net/projects/pcre/files/pcre/${RESTY_PCRE_VERSION}/pcre-${RESTY_PCRE_VERSION}.tar.gz/download -o pcre-${RESTY_PCRE_VERSION}.tar.gz \
    && tar -zxvf pcre-${RESTY_PCRE_VERSION}.tar.gz \
    && wget -c https://github.com/chobits/ngx_http_proxy_connect_module/archive/refs/tags/v${NGX_PROXY_CONNECT_VERSION}.tar.gz -O ngx_http_proxy_connect_module-${NGX_PROXY_CONNECT_VERSION}.tar.gz \
    && tar -zxvf ngx_http_proxy_connect_module-${NGX_PROXY_CONNECT_VERSION}.tar.gz \
    && wget -c https://github.com/yaoweibin/nginx_upstream_check_module/archive/refs/tags/v${NGX_UPS_CHECK_VERSION}.tar.gz -O nginx_upstream_check_module-${NGX_UPS_CHECK_VERSION}.tar.gz \
    && tar -zxvf nginx_upstream_check_module-${NGX_UPS_CHECK_VERSION}.tar.gz \
    # openresty相关
    && wget -c https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz \
    && tar -zxvf openresty-${RESTY_VERSION}.tar.gz \
    # nginx patch相关
    && cd /tmp/openresty-${RESTY_VERSION}/bundle/nginx-${NGX_VERSION}/ \
    && patch -p1 < /tmp/nginx_upstream_check_module-${NGX_UPS_CHECK_VERSION}/check_${UPS_CHECK_PATCH_VERSION}.patch \
    && patch -p1 < /tmp/ngx_http_proxy_connect_module-${NGX_PROXY_CONNECT_VERSION}/patch/proxy_connect_rewrite_${CONNECT_PATCH_VERSION}.patch \ 
    && cd /tmp/openresty-${RESTY_VERSION} \
    && ./configure -j${RESTY_J} ${RESTY_CONFIG_OPTIONS} ${RESTY_CONFIG_DEPS} \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install \
    && cd /tmp \
    && rm -rf \
        openresty-${RESTY_VERSION} \
        openresty-${RESTY_VERSION}.tar.gz \
        openssl-${RESTY_OPENSSL_VERSION} \
        openssl-${RESTY_OPENSSL_VERSION}.tar.gz \
        pcre-${RESTY_PCRE_VERSION} \
        pcre-${RESTY_PCRE_VERSION}.tar.gz \
        ngx_http_proxy_connect_module-${NGX_PROXY_CONNECT_VERSION}.tar.gz \
        ngx_http_proxy_connect_module-${NGX_PROXY_CONNECT_VERSION} \
        nginx_upstream_check_module-${NGX_UPS_CHECK_VERSION}.tar.gz \
        nginx_upstream_check_module-${NGX_UPS_CHECK_VERSION} \
    && sed -i '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond \
    && yum clean all \
    && mkdir -p /data/nginx/logs \
    && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log 

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin
ENV LUA_PATH="/usr/local/openresty/site/lualib/?.ljbc;/usr/local/openresty/site/lualib/?/init.ljbc;/usr/local/openresty/lualib/?.ljbc;/usr/local/openresty/lualib/?/init.ljbc;/usr/local/openresty/site/lualib/?.lua;/usr/local/openresty/site/lualib/?/init.lua;/usr/local/openresty/lualib/?.lua;/usr/local/openresty/lualib/?/init.lua;./?.lua;/usr/local/openresty/luajit/share/luajit-2.1.0-beta3/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/openresty/luajit/share/lua/5.1/?.lua;/usr/local/openresty/luajit/share/lua/5.1/?/init.lua"
ENV LUA_CPATH="/usr/local/openresty/site/lualib/?.so;/usr/local/openresty/lualib/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/openresty/luajit/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;/usr/local/openresty/luajit/lib/lua/5.1/?.so"

# Use SIGQUIT instead of default SIGTERM to cleanly drain requests
# See https://github.com/openresty/docker-openresty/blob/master/README.md#tips--pitfalls
STOPSIGNAL SIGQUIT
