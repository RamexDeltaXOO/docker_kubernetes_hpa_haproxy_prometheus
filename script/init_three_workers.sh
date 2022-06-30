#!/bin/bash

sudo rm /etc/containerd/config.toml
systemctl restart containerd
echo "  $ sudo kubeadm join $3:6443 --token [your_token] --discovery-token-ca-cert-hash sha256:[your_token_ca_cert_hash]"
echo "Your Token : "
read yourToken
echo "Your Your token ca cert hash : "
read yourTokenCa
sudo kubeadm join $3:6443 --token $yourToken --discovery-token-ca-cert-hash sha256:$yourTokenCa