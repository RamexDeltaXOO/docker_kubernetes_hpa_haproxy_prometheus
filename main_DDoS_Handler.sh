#!/bin/bash
echo "DDOS-HANDLER LOADING"
sleep 0.5
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
sleep 1
echo -e "
██████╗ ██████╗  ██████╗ ███████╗      ██╗  ██╗ █████╗ ███╗   ██╗██████╗ ██╗     ██████>
██╔══██╗██╔══██╗██╔═══██╗██╔════╝      ██║  ██║██╔══██╗████╗  ██║██╔══██╗██║     ██╔═══>
██║  ██║██║  ██║██║   ██║███████╗█████╗███████║███████║██╔██╗ ██║██║  ██║██║     █████╗>
██║  ██║██║  ██║██║   ██║╚════██║╚════╝██╔══██║██╔══██║██║╚██╗██║██║  ██║██║     ██╔══╝>
██████╔╝██████╔╝╚██████╔╝███████║      ██║  ██║██║  ██║██║ ╚████║██████╔╝███████╗██████>
╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═════>
                                                                                       >
"

ipMaster1 = ""
ipMaster2 = ""
ipMaster3 = ""
ipHapproxy = ""
ipCluster1 = ""
ipCluster2 = ""
ipCluster3 = ""
ipSetting = 0

install_openssh() {
        echo "0  Install openssh-client & openssh-server (all machines)"
		sh script/openssh_install.sh
}

ips_infos() {
        echo "1  Inform 3 master, 1 Happroxy & 3 Cluster IP"
		for i in 1 2 3 4 5 6 7
		do
			
			if [[ $i = 1 ]]; then
				echo "Ip master 1 : "
				read ipSet
				ipMaster1 = $ipSet
				sudo -- sh -c -e "echo '$ipMaster1 master1' >> /etc/hosts"
			elif [[ $i = 2 ]]; then
				echo "Ip master 2 : "
				read ipSet
				ipMaster2 = $ipSet
				sudo -- sh -c -e "echo '$ipMaster2 master2' >> /etc/hosts"
			elif [[ $i = 3 ]]; then
				echo "Ip master 3 : "
				read ipSet
				ipMaster3 = $ipSet
				sudo -- sh -c -e "echo '$ipMaster3 master3' >> /etc/hosts"
			elif [[ $i = 4 ]]; then
				echo "Ip Happroxy : "
				read ipSet
				ipHapproxy = $ipSet
				sudo -- sh -c -e "echo '$ipHapproxy happroxy' >> /etc/hosts"
			elif [[ $i = 5 ]]; then
				echo "Ip Cluster 1 : "
				read ipSet
				ipCluster1 = $ipSet
				sudo -- sh -c -e "echo '$ipCluster1 cluster1' >> /etc/hosts"
			elif [[ $i = 6 ]]; then
				echo "Ip Cluster 2 : "
				read ipSet
				ipCluster2 = $ipSet
				sudo -- sh -c -e "echo '$ipCluster2 cluster2' >> /etc/hosts"
			elif [[ $i = 7 ]]; then
				echo "Ip Cluster 3 : "
				read ipSet
				ipCluster3 = $ipSet
				sudo -- sh -c -e "echo '$ipCluster3 cluster3' >> /etc/hosts"
				ipSetting = 1
			fi
		done
		
		sh script/ips_info.sh
}

cfssl_install() {
        echo "2  Install cfssl (happroxy)"   
		sh script/cfssl_install.sh
}

kubectl_install() {
        echo "3 Install kubectl (happroxy)"
		sh script/kubectl_install.sh
}

happroxy_install() {
        echo "4  Install happroxy load balancer (happroxy)"
		sh script/happroxy_install.sh $ipMaster1 $ipMaster2 $ipMaster3 $ipHapproxy
}

tls_certificat() {
        echo "5  Generating TLS certificates (happroxy)"
		sh script/tls_certificat.sh
}

etcd_certificat() {
        echo "6  Creating certificate for the Etcd cluster (happroxy)"
		sh script/etcd_certificat.sh $ipMaster1 $ipMaster2 $ipMaster3 $ipHapproxy $ipCluster1 $ipCluster2 $ipCluster3
}

docker_install() {
        echo "7  Install docker (all machines except happroxy)"
		sh script/docker_install.sh
}

kube_install() {
        echo "8  Installing kubeadm, kublet, and kubectl (all machines except happroxy)"
		sh script/kube_install.sh
}

etcd_conf() {
        echo "9  Installing and configuring Etcd (3 master !one by one!)"
		sh script/etcd_conf.sh $ipMaster1 $ipMaster2 $ipMaster3 $ipHapproxy
}

init_first_master() {
        echo "10  Initializing the first master nodes (1st master node)"
		sh script/init_first_master.sh $ipMaster1 $ipMaster2 $ipMaster3 $ipHapproxy
}

init_second_master() {
        echo "11  Initializing the second master nodes (2nd master node)"
		sh script/init_second_master.sh $ipMaster1 $ipMaster2 $ipMaster3 $ipHapproxy
}

init_third_master() {
        echo "12  Initializing the third master nodes (3rd master node)"
		sh script/init_third_master.sh $ipMaster1 $ipMaster2 $ipMaster3 $ipHapproxy
}

init_three_workers() {
        echo "13  Initializing the 3 worker nodes with last token given by third master (3 worker nodes !one by one!)"
		sh script/init_three_workers.sh $ipMaster1 $ipMaster2 $ipMaster3 $ipHapproxy
}

add_permissions_admin() {
        echo "14  Add permissions to the admin.conf file (1st master node)"
		sh script/add_permissions_admin.sh
}

conf_kubectl() {
        echo "15  Configuring kubectl on the client machine (happroxy)"
		sh script/conf_kubectl.sh $ipMaster1 $ipMaster2 $ipMaster3 $ipHapproxy
}

remove_permissions_admin() {
        echo "16  Remove permissions to the admin.conf file (1st master node)"
		sh script/remove_permissions_admin.sh
}

check_access() {
        echo "17  Check access (happroxy)"
		sh script/check_access.sh
}

deploy_overlay_network() {
        echo "18  Deploying the overlay network (happroxy)"
		sh script/deploy_overlay_network.sh
}



shutdown() {
        echo  "9 chossen ShutDown"
		exit
}

quit() {
        echo "You left the DDoS Handler !"
		exit
}

print_command() {

echo "*************************************"
echo "*************************************"
echo ""
  # GNU nano 5.4                             DDOS-H_main.sh                                     
echo ""

echo "0) Install openssh-client & openssh-server (all machines)"
echo "1) Inform 3 master, 1 Happroxy & 3 Cluster IP's"
echo "2) Install cfssl (happroxy)"
echo "3) Install kubectl (happroxy)"
echo "4) Install happroxy load balancer (happroxy)"
echo "5) Generating TLS certificates (happroxy)"
echo "6) Creating certificate for the Etcd cluster (happroxy)"
echo "7) Install docker (all machines except happroxy)"
echo "8) Installing kubeadm, kublet, and kubectl (all machines except happroxy)"
echo "9) Installing and configuring Etcd (3 master !one by one!)"
echo "10) Initializing the first master nodes (1st master node)"
echo "11) Initializing the second master nodes (2nd master node)"
echo "12) Initializing the third master nodes (3rd master node)"
echo "13) Initializing the 3 worker nodes with last token given by third master (3 worker nodes !one by one!)"
echo "14) Add permissions to the admin.conf file (1st master node)"
echo "15) Configuring kubectl on the client machine (happroxy)"
echo "16) Remove permissions to the admin.conf file (1st master node)"
echo "17) Check access (happroxy)"
echo "18) Deploying the overlay network (happroxy)"
echo "19) Shut down"
echo "Q) Quit"

echo ""
echo "*************************************"
echo "*************************************"
echo ""


}

rep="stay"
while [ $rep != 'Q' ]
do

        print_command
        echo "Select your action: "
        read rep

        echo ""

        case $rep in
                "0") 
                install_openssh;;
                "1") 
                ips_infos;;
                "2") 
                cfssl_install;;
                "3") 
                kubectl_install;;
                "4") 
                happroxy_install;;
                "5") 
                tls_certificat;;
                "6")
                etcd_certificat;;
                "7")
				docker_install;;
				"8")
				kube_install;;
				"9")
				etcd_conf;;
				"10")
				init_first_master;;
				"11")
				init_second_master;;
				"12")
				init_third_master;;
				"13")
				init_three_workers;;
				"14")
				add_permissions_admin;;
				"15")
				conf_kubectl;;
				"16")
				remove_permissions_admin;;
				"17")
				check_access;;
				"18")
				deploy_overlay_network;;
				"19")
				docker_install;;
                shutdown;;
                "Q")   
                quit;;
        esac
done