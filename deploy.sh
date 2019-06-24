#!/bin/bash

LOGFILE=~/reddit_inst.log
DateStr=$(date +"%Y-%m-%d %H:%M:%S")

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

