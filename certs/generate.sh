#!/bin/bash
openssl genrsa -out ca.key 2048
openssl req -x509 -new -noenc -key ca.key -subj "/CN=etcd-ca" -days 7300 -out ca.crt \
  -addext "basicConstraints=critical,CA:TRUE" \
  -addext "keyUsage=critical,digitalSignature,keyCertSign,cRLSign"
