#!/bin/sh -e

docker-compose stop
docker-compose rm -f
docker-compose build
docker-compose run --rm lua-etcd lua test_etcd.lua
