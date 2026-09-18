#!/bin/bash
docker exec $@ /usr/local/bin/etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ssl/ca.crt \
  --cert=/etc/etcd/ssl/etcd.crt \
  --key=/etc/etcd/ssl/etcd.key \
  endpoint status -w table

  # member list
  # endpoint --help

      # - ./certs/ca.crt:/etc/etcd/ssl/ca.crt
      # - ./certs/etcd-node1.crt:/etc/etcd/ssl/etcd.crt
      # - ./certs/etcd-node1.key:/etc/etcd/ssl/etcd.key
