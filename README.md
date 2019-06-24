# ivbor7_infra

##ivbor7 Infra repository prepared for checking the home tasks and commit status integration with the team chat.
## HW#1
 - .github/PULL_REQUEST_TEMPLATE.md - PR template
 - play-travis/test.py - script for testing TravisCI
 - .travis.yml - config file for the Slack+TravisCI integration

## HW#2
  - [x] **ssh_keys were generated and public key ~/.ssh/appuser.pub added to the GCP Metadata section:**

```$ ssh-keygen -t rsa -f ~/.ssh/appuser -C appuser -P ""```

  - [x] **two VM instances were created:**
  1. bastion - bastion.us-central1-a.c.infra-244305.internal
     - int.IP: 10.128.0.4 (nic0)
     - ext.IP: 35.239.174.199
  2. someinternalhost - someinternalhost.us-central1-a.c.infra-244305.internal
     - int.IP: 10.128.0.5 (nic0)
     - ext.IP: none

  the final configuration of the VM-instances is as follows:
    bastion_IP = 35.239.174.199
    someinternalhost_IP = 10.128.0.5

  - [x] **ssh accessibility passed successfully :**

```
$ ssh -i ~/.ssh/appuser appuser@35.239.174.199
...
appuser@bastion:~$
```

  - [x] **Task-1:**
    - connect to remote "someinternalhost" via ssh running one command:
```
$ ssh -i ~/.ssh/appuser -tA appuser@35.239.174.199 ssh 10.128.0.5
appuser@someinternalhost:~$ who
appuser  pts/0        Jun 20 10:08 (10.128.0.4)

$ appuser@someinternalhost:~$ logout
Connection to 10.128.0.5 closed.
Connection to 35.239.174.199 closed.
```

  - [x] **Additional task-2: connect to "someinternalhost" via ssh running the alias command like $ someinternalhost**
    - add alias command in ~/.bashrc:
```
$ alias someinternalhost='ssh -i ~/.ssh/appuser -tA appuser@35.239.174.199 ssh 10.128.0.5'
```
*Checking:*
```
$ someinternalhost
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-1034-gcp x86_64)
...
Last login: Thu Jun 20 10:08:52 2019 from 10.128.0.4
appuser@someinternalhost:~$
```
   - or create/setup ~/.ssh/config file on the local host:
```
Host someinternalhost
 Hostname 10.128.0.5
 Port 22
 User appuser
 IdentityFile ~/.ssh/appuser.pub
 ProxyCommand ssh -W %h:%p appuser@35.239.174.199
```

*Checking:*
```
$ someinternalhost
...
appuser@someinternalhost:~$ who
appuser  pts/0        Jun 20 12:48 (10.128.0.4)
```
  - [x] **VPN server Pritunl was installed**
  - [x] **VPN-connection on local machine was created**

*Checking*
```
# ip a show tun0
4: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none
    inet 192.168.243.2/24 brd 192.168.243.255 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::344e:8da0:5244:904a/64 scope link flags 800
       valid_lft forever preferred_lft forever
```
 - [x] **mongodb and Pritunl VPN-server were installed on bastion server:**

  - setupvpn.sh  - Pritunl VPN-server script
  - Otus_test_vpn-15344.ovpn - config file for vpn client was added and renamed to cloud-bastion.ovpn executing the following command:
```
 $ git mv Otus_test_vpn-15344.ovpn ./cloud-bastion.ovpn
```

  - [x] **Additional task-3: trusted SSL-certificates for VPN-server was obtained from the letsencrypt.org ACME server and applyed**

## HW#4
 - [x] **new cloud-testapp branch was created for HW#4**
 - [x] **folder VPN created, setupvpn.sh and cloud-bastion.ovpn files moved in this folder running command "$ git mv"**
 - [x] **gcloud installed on local machine using this link https://cloud.google.com/sdk/docs/;**
 - [x] **VM instance created via gcloud;**
   - the gcloud command for creating the VM instance localy via cli is presented below:
```
 $ gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure\
  --metadata-from-file startup-script=$HOME/Scripts/startup_script.sh

  Created [https://www.googleapis.com/compute/v1/projects/infra-244305/zones/us-central1-a/instances/reddit-app].
NAME        ZONE           MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
reddit-app  us-central1-a  g1-small                   10.128.0.8   35.226.88.148  RUNNING
```
  - in this command the startup_script.sh was used for installing Ruby, MongoDB and deploying test application
  - final parameters of the VM:
    - testapp_IP = 35.226.88.148
    - testapp_port = 9292

 - [x] **ruby and bundle were installed:**
```
$ sudo apt update
$ sudo apt install -y ruby-full ruby-bundler build-essential```
```
  - install_ruby.sh - Ruby setup script added to repository

 - [x] **mongodb was installed by command:**
```
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
$ sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
```
  - install_mongodb.sh - Mongodb setup script added to repository

 - [x] **test app was deployed with help of deploy.sh script that created and added into the repository**

 - [x] **Extra tasks:**
  - [x] startup_script.sh - script was designed to automate the creation of VM instance and deploy the test application on it.

  - [x] the firewall rull was removed from web and added via gcloud console:
```
  $ gcloud compute --project=infra-244305 firewall-rules create default-puma-server\
  --description="rules for puma-server for test app"\
  --direction=INGRESS\
  --priority=1000\
  --network=default\
  --action=ALLOW\
  --rules=tcp:9292\
  --source-ranges=0.0.0.0/0\
  --target-tags=puma-server
```
