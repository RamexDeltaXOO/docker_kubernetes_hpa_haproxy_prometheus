#!/bin/bash

rm ~/pki/apiserver.*
sudo mv ~/pki /etc/kubernetes/
echo "Choose pod Subnet range IP with mask example (10.30.0.0/24) : \n"
read subnetIp
tee -a config.yaml <<EOF
[Unit]
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: stable
apiServerCertSANs:
- 10.10.10.93
controlPlaneEndpoint: "10.10.10.93:6443"
etcd:
  external:
    endpoints:
    - https://$1:2379
    - https://$2:2379
    - https://$3:2379
    caFile: /etc/etcd/ca.pem
    certFile: /etc/etcd/kubernetes.pem
    keyFile: /etc/etcd/kubernetes-key.pem
networking:
  podSubnet: $subnetIp
apiServerExtraArgs:
  apiserver-count: "3"
EOF

sudo rm /etc/containerd/config.toml
systemctl restart containerd
sudo kubeadm init --config=config.yaml
# ici rajouter le new_config.yaml et remodifier par dessus le new_config.yaml en rajoutant certSANs et extraArgs

sudo scp -r /etc/kubernetes/pki master2@$2:~
sudo scp -r /etc/kubernetes/pki master3@$3:~