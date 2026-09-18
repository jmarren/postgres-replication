FROM postgres:18.6-alpine
ARG NODE_ID

# download etcd
RUN wget https://github.com/etcd-io/etcd/releases/download/v3.5.17/etcd-v3.5.17-linux-amd64.tar.gz

# extract
RUN tar xvf etcd-v3.5.17-linux-amd64.tar.gz

# move to etcd/
RUN mv etcd-v3.5.17-linux-amd64 etcd

# move etcd binaries to usr/local/bin
RUN mv etcd/etcd* /usr/local/bin/

# RUN chmod +x /usr/local/bin/etcd

# add an etcd system user 
RUN adduser --system --home /var/lib/etcd --shell /bin/false etcd
RUN addgroup --system etcd

# copy in cert files
COPY --chown=etcd:etcd ./certs/etcd-node$NODE_ID.crt /etc/etcd/ssl/etcd-node$NODE_ID.crt
COPY --chown=etcd:etcd ./certs/etcd-node$NODE_ID.key /etc/etcd/ssl/etcd-node$NODE_ID.key
COPY --chown=etcd:etcd ./certs/ca.crt /etc/etcd/ssl/ca.crt

# update permissions for copied files
RUN chmod 600 /etc/etcd/ssl/etcd-node*.key
RUN chmod 644 /etc/etcd/ssl/etcd-node*.crt /etc/etcd/ssl/ca.crt

RUN mkdir /etc/init.d

# Install OpenRC and create the required runtime directories
RUN apk add --no-cache openrc \
    && mkdir -p /run/openrc \
    && touch /run/openrc/softlevel
# touch /run/openrc/softlevel
# Install openrc
# RUN apk update && apk add openrc &&\
# # Tell openrc its running inside a container, till now that has meant LXC
#     sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf &&\
# # Tell openrc loopback and net are already there, since docker handles the networking
#     echo 'rc_provide="loopback net"' >> /etc/rc.conf &&\
# # no need for loggers
#     sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf &&\
# # can't get ttys unless you run the container in privileged mode
#     sed -i '/tty/d' /etc/inittab &&\
# # can't set hostname since docker sets it
#     sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname &&\
# # can't mount tmpfs since not privileged
#     sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh &&\
# # can't do cgroups
#     sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh &&\
# # clean apk cache
#     rm -rf /var/cache/apk/*


# RUN mkdir -p /etc/apk && echo "http://alpine.gliderlabs.com/alpine/edge/main" > /etc/apk/repositories
# RUN apk add --no-cache openrc 

# RUN mkdir -p /lib/rc/sh
# RUN touch /lib/rc/sh/init.sh

# RUN sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf
# RUN echo 'rc_provide="loopback net"' >> /etc/rc.conf
# RUN sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf
# RUN sed -i '/tty/d' /etc/inittab 
# RUN sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname
# # RUN sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh 
# # RUN sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh 
# RUN rm -rf /var/cache/apk/*
#


RUN touch /dev/tty1

RUN <<EOF
cat > /etc/etcd/etcd.env << EOT
ETCD_NAME="postgresql-${NODE_ID}"
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_INITIAL_CLUSTER="postgresql-1=https://postgres-1:2380,postgresql-2=https://postgres-2:2380,postgresql-3=https://postgres-3:2380"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://postgres-${NODE_ID}:2380"
ETCD_LISTEN_PEER_URLS="https://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="https://0.0.0.0:2379"
ETCD_ADVERTISE_CLIENT_URLS="https://postgres-${NODE_ID}:2379"
ETCD_CLIENT_CERT_AUTH="true"
ETCD_TRUSTED_CA_FILE="/etc/etcd/ssl/ca.crt"
ETCD_CERT_FILE="/etc/etcd/ssl/etcd-node1.crt"
ETCD_KEY_FILE="/etc/etcd/ssl/etcd-node1.key"
ETCD_PEER_CLIENT_CERT_AUTH="true"
ETCD_PEER_TRUSTED_CA_FILE="/etc/etcd/ssl/ca.crt"
ETCD_PEER_CERT_FILE="/etc/etcd/ssl/etcd-node${NODE_ID}.crt"
ETCD_PEER_KEY_FILE="/etc/etcd/ssl/etcd-node${NODE_ID}.key"
EOT
EOF


RUN rm -rf /etc/init.d/*



RUN <<EOF
cat > /etc/init.d/etcd <<EOT
#!/sbin/openrc

description="etcd"
description_documentation="https://github.com/etcd-io/etcd"

command="/usr/local/bin/etcd"
# command_user="etcd:etcd"
command_background="yes"
pidfile="/run/${RC_SVCNAME}.pid"

directory="/var/lib/etcd"

# equivalent of EnvironmentFile=
etcd_env="/etc/etcd/etcd.env"

# equivalent of Restart=always / RestartSec=10s
respawn_max=0
respawn_delay=10

# equivalent of LimitNOFILE=40000
rc_ulimit="-n 40000"

# equivalent of After=/Wants=network-online.target

EOT
EOF



# depend() {
# 	need net
# 	use dns
# 	after net-online
# }

# start_pre() {
# 	checkpath -d -m 0750 -o "${command_user}" "${directory}"
#
# 	if [ -f "${etcd_env}" ]; then
# 		set -a
# 		. "${etcd_env}"
# 		set +a
# 	fi
# }

RUN chmod +x /etc/init.d/etcd 



RUN mkdir -p /var/lib/etcd 
RUN chown -R etcd:etcd /var/lib/etcd
# RUN chmod etcd:etcd /var/lib/etcd
RUN rc-update add etcd default

RUN openrc default

CMD ["postgres"]

# CMD openrc default && su postgres -c "postgres" && tail -f /dev/null

# RUN  rc-service etcd start

# CMD  /sbin/init

# CMD ["postgres"]




	# \
	# apk add --no-cache --virtual .gosu-deps \
	# 	ca-certificates \
	# 	dpkg \
	# 	gnupg \
	# ; \
	# \
	# dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	# wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	# wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; 

# install etcd
# RUN wget https://github.com/etcd-io/etcd/releases/download/v3.5.17/etcd-v3.5.17-linux-amd64.tar.gz
# SHELL ["/bin/bash", "-c"]
# RUN su - root -c "rc-update add etcd default"
# RUN rc-service etcd reload
# RUN su -s /bin/bash -c "rc-service etcd start" etcd
# RUN su - root -c "rc-service etcd start"
