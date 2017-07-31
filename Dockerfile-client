FROM syutingsong/shadowsocks-libev

EXPOSE 1080
CMD ss-local -s $SERVER_ADDR \
             -p $SERVER_PORT \
             -l 1080 \
             -b 0.0.0.0 \
             -k ${PASSWORD:-$(hostname)} \
             -m $METHOD \
             -t $TIMEOUT \
             $ARGS

