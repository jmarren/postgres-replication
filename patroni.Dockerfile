FROM postgres:18.6-alpine
RUN apk add py3-pip python3-dev build-base linux-headers libffi-dev py3-psycopg2 acl

ARG NODE_ID



# etcd certs
# COPY --chown=postgres:postgres --chmod=644 ./certs/ca.crt /etc/etcd/ssl/ca.crt
# COPY --chown=postgres:postgres --chmod=644 ./certs/etcd-node${NODE_ID}.crt /etc/etcd/ssl/etcd.crt
# COPY --chown=postgres:postgres --chmod=600 ./certs/etcd-node${NODE_ID}.key /etc/etcd/ssl/etcd.key
#
# COPY --chown=postgres:postgres --chmod=644 ./certs/ca.crt /etc/patroni/ssl/ca.crt
# COPY --chown=postgres:postgres --chmod=644 ./certs/etcd-node${NODE_ID}.crt /etc/patroni/ssl/etcd.crt
# COPY --chown=postgres:postgres --chmod=600 ./certs/etcd-node${NODE_ID}.key /etc/patroni/ssl/etcd.key

# postgres certs
COPY --chown=postgres:postgres --chmod=600 ./certs/etcd-node1.key /etc/patroni/ssl/etcd.key
COPY --chown=postgres:postgres --chmod=644 ./certs/server.crt /var/lib/postgresql/ssl/server.crt
COPY --chown=postgres:postgres --chmod=644 ./certs/server.key /var/lib/postgresql/ssl/server.key
COPY --chown=postgres:postgres --chmod=644 ./certs/server.req /var/lib/postgresql/ssl/server.req
COPY --chown=postgres:postgres --chmod=644 ./certs/server.pem /var/lib/postgresql/ssl/server.pem
 


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

RUN python3 -m venv .venv

RUN pip install --break-system-packages etcd3 patroni[etcd] 


  # cacert: /etc/etcd/ssl/ca.crt
  # cert: /etc/etcd/ssl/etcd.crt  # node1's etcd certificate
  # key: /etc/etcd/ssl/etcd.key  # node1's etcd key

# RUN adduser 


CMD su postgres -c "patroni /etc/patroni/config.yaml"
# CMD ["patroni", "/etc/patroni/config.yaml"]


