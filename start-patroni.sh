#!/bin/bash
chown postgres:postgres /etc/patroni/ssl/etcd.key
chown postgres:postgres /etc/patroni/ssl/server.key
su postgres -c "patroni /etc/patroni/config.yaml"
