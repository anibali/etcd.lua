FROM anibali/lua:5.2

# Install required Lua modules
RUN apk add --update gcc lua5.2-dev musl-dev git \
    && export C_INCLUDE_PATH=/usr/include/lua5.2/ \
    && luarocks install lua-cjson \
    && luarocks install luasocket \
    && apk del gcc lua5.2-dev musl-dev git \
    && rm -rf /var/cache/apk/*

# Copy our files into the image
COPY . /app

WORKDIR /app

ENTRYPOINT ["/usr/bin/tini", "--"]
