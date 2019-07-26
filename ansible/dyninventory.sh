#!/bin/bash

#set a

PROGRAM=`basename $0`

#=================================================================
# Printing Script Usage.
#=================================================================
function prn_help() {
    echo "Usage:  ${PROGRAM} <ONE option>"
    echo
    echo "<ONE option>:"
    echo "  --list	Generate inventory in json format."
    echo "  --host	Generate "
    echo "-------------------------------------------------------"
}

cd  ../terraform/stage

DB_IP=$(terraform output -json db_ext_ip | jq ".value")
APP_IP=$(terraform output -json app_ext_ip | jq ".value")

#APP_IP="35.232.138.12"
#DB_IP="34.66.78.42"
#echo "$1"
#echo "$PROGRAM"
#echo $AP_PIP
#echo $DB_IP

export APP_IP DB_IP

case "$1" in

   --list)
       envsubst < ../../ansible/dyninv.tpl;
       exit 0;
       ;;

   --host)
       echo '{ "_meta": { "hostvars": {}}}';
       exit 0;
       ;;

         *)
       prn_help
       exit 1;
       ;;
esac
