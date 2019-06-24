#!/bin/bash

LOGFILE=~/mongo_install.log
echo "$(date "+%Y%m%d %T"): The mongodb installation starts:" >> $LOGFILE 2>&1


sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

sudo apt update

sudo apt install -y mongodb-org

if [[ $? -eq 0 ]]; then echo "$(date "+%Y%m%d %T"): -mongodb- installed successfully "  >> $LOGFILE 2>&1
else echo "$(date "+%Y%m%d %T"): -mongodb- installation failed. Error code: $? "  >> $LOGFILE 2>&1
fi

sudo systemctl start mongod  
sudo systemctl enable mongod
sudo systemctl status mongod | egrep -i "load|active" >> $LOGFILE 2>&1
