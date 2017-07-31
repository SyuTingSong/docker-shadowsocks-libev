## Usage

Start the shadowsocks-libev server:

```sh
docker run -d --rm \
    -e SERVER_PORT=8388
    -e PASSWORD=foobar \
    -e METHOD=aes-128-gcm \
    -p 8388:8388 \
    syutingsong/shadowsocks-libev
```

Client:

```sh
docker run -d --rm \
    -e SERVER_ADDR=202.106.224.68 \
    -e SERVER_PORT=8388 \
    -e PASSWORD=foobar \
    -e METHOD=aes-128-gcm \
    -p 127.0.0.1:1080:1080 \
    syutingsong/shadowsocks-libev:client
```

