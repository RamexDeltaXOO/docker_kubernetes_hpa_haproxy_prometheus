#!/bin/bash

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install haproxy
printf "frontend kubernetes\nbind $4:6443\noption tcplog\nmode tcp\ndefault_backend kubernetes-master-nodes\n\nbackend kubernetes-master-nodes\nmode tcp\nbalance roundrobin\noption tcp-check\nserver k8s-master-0 $1:6443 check fall 3 rise 2\nserver k8s-master-1 $2:6443 check fall 3 rise 2\nserver k8s-master-2 $3:6443 check fall 3 rise 2" >> /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy