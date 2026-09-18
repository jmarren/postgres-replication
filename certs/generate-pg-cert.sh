#!/bin/bash
openssl genrsa -out server.key 2048 # private key
openssl req -new -key server.key -out server.req # csr
openssl req -x509 -key server.key -in server.req -out server.crt -days 7300
# generate cert, valid for 20 years

cat server.crt server.key > server.pem
# sudo sh -c 'cat /var/lib/postgresql/ssl/server.crt /var/lib/postgresql/ssl/server.key > /var/lib/postgresql/ssl/server.pem'
# sudo chown postgres:postgres /var/lib/postgresql/ssl/server.pem
# sudo chmod 600 /var/lib/postgresql/ssl/server.pem
