#!/bin/bash

scp master1@$1:/etc/kubernetes/admin.conf .
mkdir ~/.kube
mv admin.conf ~/.kube/config
chmod 600 ~/.kube/config