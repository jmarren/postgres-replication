#!/bin/bash
# chown -R 999:999 /var/lib/postgresql/18/docker
# rm -rf /var/lib/postgresql/18/docker
# echo "PWD = $PWD"
# mkdir /var/lib/postgresql/data
# pg_basebackup -h primary -U repuser --checkpoint fast -D /var/lib/postgresql/data -R


# rm -rf /var/lib/postgresql/18/docker/* &&
# pg_basebackup -h primary -U repuser -D /var/lib/postgres/18/data -Fp -Xs -R &&
# chown -R postgres:postgres /var/lib/postgres &&
# exec docker-entrypoint.sh postgres -D /var/lib/postgres/18/data
