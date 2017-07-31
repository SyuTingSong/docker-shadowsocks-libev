FROM alpine:3.6

ENV SERVER_ADDR=0.0.0.0 SERVER_PORT=8388 PASSWORD=foobar METHOD=aes-256-gcm\
    TIMEOUT=300 DNS_ADDR=8.8.8.8 DNS_ADDR_2=8.8.4.4
ENV ARGS=--fastopen


RUN apk add --no-cache --virtual .build-deps gcc autoconf\
    libtool automake make zlib-dev openssl-dev asciidoc xmlto\
    linux-headers git musl-dev pcre-dev mbedtls-dev libsodium-dev\
    udns-dev libev-dev &&\
    cd /tmp &&\

    git clone https://github.com/shadowsocks/shadowsocks-libev.git &&\
    cd shadowsocks-libev &&\
    git submodule init && git submodule update &&\
    ./autogen.sh &&\
    ./configure && make && make install &&\
    cd / &&\

    runDeps="$( \
        scanelf --needed --nobanner /usr/local/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" &&\
    apk add --no-cache --virtual .run-deps $runDeps &&\
    apk del .build-deps &&\
    rm -rf /tmp/*

USER nobody
EXPOSE $SERVER_PORT
CMD ss-server -s $SERVER_ADDR \
              -p $SERVER_PORT \
              -k ${PASSWORD:-$(hostname)} \
              -m $METHOD \
              -t $TIMEOUT \
              -d $DNS_ADDR \
              -d $DNS_ADDR_2 \
              -u \
              $ARGS

