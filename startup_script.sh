#!/bin/bash
LOGFILE=/var/log/reddit_inst.log
DateStr=$(date +"%Y-%m-%d %H:%M:%S")

##############################################################################
# Ruby setup section
#############################################################################
echo "$DateStr Ruby installation starts:" >> $LOGFILE 2>&1

sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

if [[ $? -eq 0 ]]; then echo "$DateStr -Ruby- installed successfully "  >> $LOGFILE 2>&1
else echo "$DateStr -Ruby- installation failed. Error code: $? "  >> $LOGFILE 2>&1
fi

echo -e  "$DateStr $(ruby -v && bundle -v) : \n$DateStr: Ruby  installation completed" >> $LOGFILE 2>&1

###############################################################################
# MongoDb setup section
###############################################################################

echo "$DateStr --/MongoDb-- installation starts:" >> $LOGFILE 2>&1

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt update
sudo apt install -y mongodb-org

if [[ $? -eq 0 ]]; then echo "$DateStr -mongodb- installed successfully "  >> $LOGFILE 2>&1
else echo "$DateStr -mongodb- installation failed. Error code: $? "  >> $LOGFILE 2>&1
fi

sudo systemctl start mongod  
sudo systemctl enable mongod

echo -e "$(sudo systemctl status mongod | egrep -i "load|active")\n$DateStr MongoDb installation completed" >> $LOGFILE 2>&1

###############################################################################
# Reddit app  deploy section
###############################################################################

echo "$DateStr Reddit deploying starts:" >> $LOGFILE 2>&1

cd /home/appuser/
git clone -b monolith https://github.com/express42/reddit.git

# install app's dependencies
cd reddit && bundle install

if [[ $? -eq 0 ]]; then echo "$DateStr -bundle- installed successfully "  >> $LOGFILE 2>&1
else echo "$DateStr -- installation failed. Error code: $? "  >> $LOGFILE 2>&1
fi

sudo gem install bundler
if [[ $? -eq 0 ]]; then echo "$DateStr -bundler- installed successfully "  >> $LOGFILE 2>&1
else echo "$DateStr -- installation failed. Error code: $? "  >> $LOGFILE 2>&1
fi

# run the app's  server
puma -d

# checking port app running on
_st=$(ps -aux |grep puma | grep -v grep | awk -F: '/tcp/{print $5}' | egrep -o "^[0-9]{1,5}")

# if [ -z $_st ];  then echo "Reddit is not running"; else echo "Reddit server is running on $_st port"; fi

if [[ ! -z $_st ]]; then echo "$DateStr Reddit Deploying completed. Server is running on $_st port" >> $LOGFILE 2>&1
else
echo "Reddit server startup failed. For details see log $LOGFILE" >> $LOGFILE 2>&1
fi
