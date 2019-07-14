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
  testapp_IP = 35.226.88.148
  testapp_port = 9292

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

## HW#5

 - [x] the VM image with option "--image-family=reddit-base" baked using Packer
 and the ubuntu16.json template was created for this task. Also the variables.json.example was created
 and added to repository instead of the variables.json that filtered with .gitignore for security reasons.
 To validate the packer template run this command:
 ` $ packer validate -var-file=variables.json ubuntu16.json`
 and to build the image reddit-base with mongodb and ruby installed run command:
 ` $ packer build -var-file=variables.json ubuntu16.json`

 - [x] the immutable.json template was created for "backing" the VM full image with reddit application deployed on-board. The previously created reddit-base family image is used for full immutable image creation.
 "--image-family=reddit-full" assigned to the immutable image. All required files for creating the image are placed
 in packer/files and packer/scripts folders.
  To build the reddit-full image with reddit application inside run command:
 `$ packer build -var-file=variables.json immutable.json`
Inside VM the puma-server will start due to puma.service created and provisioned via immutable.json.

 - [x] - Create shell-script create-reddit-vm.sh in config-scripts directory to run the VM instance with running reddit application inside.


## HW#6 (terraform-1 branch)
 - install the tfswitch the command line tool that let you switch between defferent versions of terraform:
``` $ curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash```
for more details follow this link: https://warrensbox.github.io/terraform-switcher/ (or more complex way https://blog.gruntwork.io/installing-multiple-versions-of-terraform-with-homebrew-899f6d124ff9)
 - the provider plugins was initialized by running the command in terraform folder with it's main config `$ sudo terraform -v`
 - [x] - ssh-key for the appuser_web were added into the project metadata. New ssh-key appeared in the list of ssh-keys
  and after executing the command `$ terraform apply` this ssh-key was removed. During the execution Terraform determined
  the differences between current project state and the changes prepared to apply. As the current state was different
  from the required one, so the project infrastructure was aligned with that specified in main.tf config file.
 - [x] - input variable for zone created and the default value is assigned to it in terraform.tvars (see description in terraform.tvars.example)
 - [x] - all config file were formated with help `$ terraform fmt`;
 - [x] - terraform.tfvars filtered within .gitignore and was replaced in the repository by terraform.tfvars.example as
 - [x] - input sshkey-variable for provisioner's connection was declared via resource "google_compute_project_metadata_item":
```
  resource "google_compute_project_metadata_item" "app_multiuserssh" {
  key = "ssh-keys"
  value = "${var.ssh_user}:${file(var.public_key_path)} \n${var.ssh_user1}:${file(var.public_key_path)} \n${var.ssh_user2}:${file(var.public_key_path)}"
}
  ```
 - [x] - within the scope of extra tasks with "*" and "**" the HTTP Load Balancer was discribed in lb.tf in terraform code fashion

 HTTP Load Balancing was described in terraform code using the following resources:
  - google_compute_backend_service.reddit-backend

  - google_compute_global_forwarding_rule.reddit-forward

  - google_compute_http_health_check.reddit-health

  - google_compute_instance.app[count]

  - google_compute_instance_group.reddit-cluster

  - google_compute_project_metadata_item.app_multiuserssh

  - google_compute_target_http_proxy.reddit-target-proxy

  - google_compute_url_map.reddit-lb

 For multiple instances creating the "count" parameter was used:

```
# main.tf:
# specify the number of instances
  count        = "${var.count_instance}"
# and change the name of instance appropriatly
  name         = "reddit-app-${count.index}"

# default value assigned in the  variables.tf:
variable count_instance {
  description = "number of instances"
  default     = 1
}

# The required number of app instances is set in terraform.tvars:
count_instance = 2
```

## HW#7 (terraform-2 branch)
This work is devoted to the transition to the use of modules in the description of the infrastructure.
To implement such an approach the following tasks were accomplished:
 - [x] - the firewall rule for ssh access management via terraform was imported running the following command:
 ```terraform import google_compute_firewall.firewall_ssh default-allow-ssh```
 - [x] - two templates db.json and app.json were created to bake two separate imagies for application and database instances using packer
```
 $ packer build -var-file=variables.json app.json
 $ packer build -var-file=variables.json db.json
```
 - [x] - three local modules: app, db and vpc were implemented then described in main.tf:
```
  module "app" {
  source          = "modules/app"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  app_disk_image  = "${var.app_disk_image}"
  count_instance  = "${var.count_instance}"
}

module "db" {
  source          = "modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
}

module "vpc" {
  source          = "modules/vpc"
#  source_ranges = ["178.94.15.151/32"]
  source_ranges   = ["0.0.0.0/0"]
}
```
 - to start using these modules run the command: `$ terraform get`

 - [x] - create the "prod" and "stage" environments
 - [x] - extra task: organize storing the state-file on the remote storage-bucket separate one for each env (*)
Using the storage-bucket module the two buckets were created and discribed in backend.tf files for stage and prod envs respectively:
```
# terraform backend.tf for storage env
terraform {
  backend "gcs" {
    bucket = "ivb-trform-stage"
    prefix = "reddit-stage"
  }
}
```

An attempt to create VM instances in "prod" and "stage" environments simultaneously causes an error due to creating the .tflock-file on the remote storage that exists during the entire period of applying the configuration:        \
> Do you want to perform these actions?
>  Terraform will perform the actions described above.
>  Only 'yes' will be accepted to approve.
>
>  Enter a value: yes
>
> Releasing state lock. This may take a few moments...
>
> Error: Apply cancelled.


