FROM shadowsocks/shadowsocks-libev

ENV SERVER_ADDR 0.0.0.0
ENV PORT        8080
ENV PASSWORD    jb1314926
ENV METHOD      chacha20
ENV TIMEOUT     600
ENV DNS_ADDRS   8.8.8.8,8.8.4.4
ENV DOMAIN=
ENV ARGS=

USER root

RUN apk add --no-cache curl \
  && curl -sL https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.2.0/v2ray-plugin-linux-amd64-v1.2.0.tar.gz | tar zxC /usr/bin/ \
  && cd /usr/bin/ && mv v2ray-plugin_linux_amd64 v2ray-plugin && chmod a+x /usr/bin/v2ray-plugin && mkdir -p /root/.acme.sh
  
VOLUME /root/.acme.sh

CMD exec ss-server \
      -s $SERVER_ADDR \
      -p $PORT \
      -k ${PASSWORD:-$(hostname)} \
      -m $METHOD \
      -t $TIMEOUT \
      -d $DNS_ADDRS \
      -u \
      --plugin v2ray-plugin --plugin-opts "server;path=/ws${DOMAIN:+;tls;host=${DOMAIN}}" \
      $ARGS
