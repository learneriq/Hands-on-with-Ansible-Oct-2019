#!/bin/bash

host=${1}

if [ $# -eq 0 ]
  then
    echo -e "Remote host ip required.\nUsage:./setup.sh 34.244.168.125"
    exit
fi

# # set ssh connection to your host
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
ssh-add "ansiblePG.pem"
ssh-copy-id -i ~/.ssh/id_rsa.pub playground@${host}

echo -e "[web]\n${host}" > ./ansible_inventory && echo -e "[defaults]\ninventory = ansible_inventory\nansible_path=/usr/local/bin/python3" > ./ansible.cfg