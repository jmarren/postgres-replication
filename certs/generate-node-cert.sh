#!/bin/bash
# Generate a private key
openssl genrsa -out "etcd-node$@.key" 2048

# Create temp file for config
cat > temp.cnf <<EOF
[ req ]
distinguished_name = req_distinguished_name
req_extensions = v3_req
[ req_distinguished_name ]
[ v3_req ]
subjectAltName = @alt_names
[ alt_names ]
DNS.1 = etcd-${@}
DNS.2 = etcd-${@}.backend
DNS.3 = localhost
IP.1  = 127.0.0.1
EOF


# Create a csr
openssl req -new -key "etcd-node$@.key" -out "etcd-node$@.csr" \
  -subj "/C=US/ST=YourState/L=YourCity/O=YourOrganization/OU=YourUnit/CN=etcd-node$@" \
  -config temp.cnf

# Sign the cert
openssl x509 -req -in "etcd-node$@.csr" -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out "etcd-node$@.crt" -days 7300 -sha256 -extensions v3_req -extfile temp.cnf

# Verify the cert and be sure you see Subject Name Alternative

openssl x509 -in "etcd-node$@.crt" -text -noout | grep -A1 "Subject Alternative Name"

# Remove temp file

rm temp.cnf


# IP.1 = 192.168.60.103
# IP.2 = 127.0.0.1
