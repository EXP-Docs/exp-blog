#!/bin/sh

docker run -d --rm -v "$PWD/gitbook:/gitbook" -p 4000:4000 --name="exp-blog" expm02/gitbook-server gitbook serve