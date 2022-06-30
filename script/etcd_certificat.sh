#!/bin/bash

tee -a kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "IE",
    "L": "Cork",
    "O": "Kubernetes",
    "OU": "Kubernetes",
    "ST": "Cork Co."
  }
 ]
}
EOF

cfssl gencert \
-ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-hostname=$1,$2,$3,$4,127.0.0.1,kubernetes.default \
-profile=kubernetes kubernetes-csr.json | \
cfssljson -bare kubernetes

ls -la

scp ca.pem kubernetes.pem kubernetes-key.pem master1@$1:~
scp ca.pem kubernetes.pem kubernetes-key.pem master2@$2:~
scp ca.pem kubernetes.pem kubernetes-key.pem master3@$3:~
scp ca.pem kubernetes.pem kubernetes-key.pem cluster1@$5:~
scp ca.pem kubernetes.pem kubernetes-key.pem cluster2@$6:~
scp ca.pem kubernetes.pem kubernetes-key.pem cluster3@$7:~