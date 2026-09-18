FROM postgres:18.6-alpine

ARG NODE_ID

RUN apk add python3 build-base py3-pip python3-dev build-base linux-headers libffi-dev py3-psycopg2 acl


RUN python3 -m venv .venv


RUN pip install --break-system-packages patroni[etcd3,psycopg3] 


# USER postgres

CMD chmod +x /start.sh && /start.sh

# CMD ["patroni",  "/etc/patroni/config.yaml"]


# etcd certs
# COPY --chown=postgres:postgres --chmod=644 ./certs/ca.crt /etc/etcd/ssl/ca.crt
# COPY --chown=postgres:postgres --chmod=644 ./certs/etcd-node${NODE_ID}.crt /etc/etcd/ssl/etcd.crt
# COPY --chown=postgres:postgres --chmod=600 ./certs/etcd-node${NODE_ID}.key /etc/etcd/ssl/etcd.key-file

# COPY --chown=postgres:postgres --chmod=600 ./certs/ca.crt /etc/patroni/ssl/ca.crt
# COPY --chown=postgres:postgres --chmod=600 ./certs/etcd-node${NODE_ID}.crt /etc/patroni/ssl/etcd.crt
# COPY --chown=postgres:postgres --chmod=600 ./certs/etcd-node${NODE_ID}.key /etc/patroni/ssl/etcd.key-file

# postgres certs
# COPY --chown=postgres:postgres --chmod=600 ./certs/etcd-node1.key /etc/patroni/ssl/etcd.key
 


# RUN chmod o+x /etc
# RUN chmod o+x /etc/etcd
# RUN chmod o+x /etc/etcd/ssl

# RUN setfacl -R -m u:postgres:r /etc/patroni/ssl
# # RUN setfacl -R -m u:postgres:r /var/lib/postgresql/ssl
# RUN setfacl -m u:postgres:r /etc/patroni/ssl/ca.crt
# RUN setfacl -m u:postgres:r /etc/patroni/ssl/etcd.crt
# RUN setfacl -m u:postgres:r /etc/patroni/ssl/etcd.key
#
# RUN setfacl -R -m u:postgres:r /etc/etcd/ssl
# RUN setfacl -R -m u:postgres:r /var/lib/postgresql/ssl
# RUN setfacl -m u:postgres:r /etc/etcd/ssl/ca.crt
# RUN setfacl -m u:postgres:r /etc/etcd/ssl/etcd.crt
# RUN setfacl -m u:postgres:r /etc/etcd/ssl/etcd.key
# RUN chown -R postgres:postgres /etc/etcd
# RUN chgrp -R postgres /etc/etcd/ssl

# sudo chmod 600 /var/lib/postgresql/ssl/server.key
# sudo chmod 644 /var/lib/postgresql/ssl/server.crt
# sudo chmod 600 /var/lib/postgresql/ssl/server.req
# sudo chown postgres:postgres /var/lib/postgresql/data
# sudo chown postgres:postgres /var/lib/postgresql/ssl/server.*
#
# RUN chown postgres:postgres /etc/etcd/ssl/ca.crt  /etc/etcd/ssl/etcd.crt /etc/etcd/ssl/etcd.key


# pip install patroni[psycopg3,etcd3
  # cacert: /etc/etcd/ssl/ca.crt
  # cert: /etc/etcd/ssl/etcd.crt  # node1's etcd certificate
  # key: /etc/etcd/ssl/etcd.key  # node1's etcd key

# RUN adduser 


# CMD ["patroni", "/etc/patroni/config.yaml"]
# CMD su postgres -c "patroni /etc/patroni/config.yaml"
# CMD ["patroni", "/etc/patroni/config.yaml"]


# RUN pip install -no-cache-dir -r /dev/stdin <<EOF
# urllib3>=1.19.1,!=1.21
# boto3
# PyYAML
# kazoo>=1.3.1
# python-etcd>=0.4.3,<0.5
# py-consul>=1.1.1,<1.5.4; python_version=="3.6"
# py-consul>=1.1.1,<1.6.0; python_version>"3.6" and python_version<"3.9"
# py-consul>=1.1.1; python_version>="3.9"
# click>=5.0
# prettytable>=0.7
# python-dateutil
# pysyncobj>=0.3.8
# cryptography>=1.4
# psutil>=2.0.0
# ydiff>=1.2.0,<1.5,!=1.4.0,!=1.4.1
# python-json-logger>=2.0.2
# EOF
# # systemd-python is an optional dependency for systemd notification support.
# # OS package maintainers should add something like python3-systemd as a dependency to patroni package.

# COPY --chown=postgres:postgres --chmod=644 ./patroni-config.yaml /etc/patroni/config.yaml
# COPY --chown=postgres:postgres --chmod=644 ./certs/server.crt /etc/patroni/ssl/server.crt
# COPY --chown=postgres:postgres --chmod=600 ./certs/server.key /etc/patroni/ssl/server.key
# COPY --chown=postgres:postgres --chmod=644 ./certs/server.req /etc/patroni/ssl/server.req
# COPY --chown=postgres:postgres --chmod=600 ./certs/server.pem /etc/patroni/ssl/server.pem
# COPY --chown=postgres:postgres --chmod=644 ./certs/ca.crt /etc/patroni/ssl/ca.crt
# COPY --chown=postgres:postgres --chmod=644 ./certs/etcd-node${NODE_ID}.crt /etc/patroni/ssl/etcd.crt
# COPY --chown=postgres:postgres --chmod=600 ./certs/etcd-node${NODE_ID}.key /etc/patroni/ssl/etcd.key
#
