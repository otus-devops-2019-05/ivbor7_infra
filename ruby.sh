#!/bin/bash

LOGFILE=~/ruby_install.log
DateStr=$(date +"%Y-%m-%d %H:%M:%S")

echo "$DateStr: The installation of Ruby starts:" >> $LOGFILE 2>&1

sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

if [[ $? -eq 0 ]]; then echo "$DateStr: -Ruby- installed successfully "  >> $LOGFILE 2>&1
else echo "$DateStr: -Ruby- installation failed. Error code: $? "  >> $LOGFILE 2>&1
fi

echo -e  "$DateStr: $(ruby -v && bundle -v) : \nThe Ruby  installation completed" >> $LOGFILE 2>&1
