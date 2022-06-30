#!/bin/bash

sudo mkdir /etc/etcd /var/lib/etcd
sudo mv ~/ca.pem ~/kubernetes.pem ~/kubernetes-key.pem /etc/etcd
wget https://github.com/etcd-io/etcd/releases/download/v3.3.13/etcd-v3.3.13-linux-amd64.tar.gz
tar xvzf etcd-v3.3.13-linux-amd64.tar.gz
sudo mv etcd-v3.3.13-linux-amd64/etcd* /usr/local/bin/
ip1 = $1
ip2 = $2
ip3 = $3
echo "Master 1 : 1)\n"
echo "Master 2 : 2)\n"
echo "Master 3 : 3)\n"
read machine
if [[ $machine = "1" ]]; then
	$1 = $1
elif [[ $machine = "2" ]]; then
	$1 = $2
elif [[ $machine = "3" ]]; then
	$1 = $3
fi
tee -a /etc/systemd/system/etcd.service <<EOF
[Unit]
Description=etcd
Documentation=https://github.com/coreos


[Service]
ExecStart=/usr/local/bin/etcd \
--name $1 \
--cert-file=/etc/etcd/kubernetes.pem \
--key-file=/etc/etcd/kubernetes-key.pem \
--peer-cert-file=/etc/etcd/kubernetes.pem \
--peer-key-file=/etc/etcd/kubernetes-key.pem \
--trusted-ca-file=/etc/etcd/ca.pem \
--peer-trusted-ca-file=/etc/etcd/ca.pem \
--peer-client-cert-auth \
--client-cert-auth \
--initial-advertise-peer-urls https://$1:2380 \
--listen-peer-urls https://$1:2380 \
--listen-client-urls https://$1:2379,http://127.0.0.1:2379 \
--advertise-client-urls https://$1:2379 \
--initial-cluster-token etcd-cluster-0 \
--initial-cluster $ip1=https://$ip1:2380,$ip2=https://$ip2:2380,$ip3=https://$ip3:2380 \
--initial-cluster-state new \
--data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5



[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
ETCDCTL_API=3 etcdctl member list