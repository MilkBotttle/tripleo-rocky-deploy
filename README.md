# Tripleo Rocky
Ansible playbooks for deploy.

## Requirement
* CentOS 7
* Ansible >= 2.4

# Functions

## Install docker-ce on fresh node [x]
This docker-ce version confict with tripleo-repo because this version newer
than tripleo-repo. If you want to put offline yum repo and docker-registry
together just play prepare undercloud.

1. Play
`ansible-playbook ansible/install-docker-ce.yaml`

## Prepare offline image tarball
This will install docker registry, pull images from docker hub and archive
registry convenience move to other node.

1. Edit environment file `ansible/environment.yaml`
2. Play 
`ansible-playbook -e @ansible/environment.yaml ansible/create-tripleo-images-registry-tarball.yaml`

## Prepare offline registry
This will install docker registry, move images to registry.

1. Edit environment file `ansible/environment.yaml`
2. Play
`ansible-playbook -e @ansible/environment.yaml ansible/create-offline-registry.yaml`

## Test local registry is ok
This task pull all images from local registry to check.

1. Play
`ansible-playbook -e "registry_server=<ip> -e "registry_port=<port>" ansible/check-local-registry.yaml`

## Prepare undercloud deploy
This will install tripleo repo, if `local_registry` is true will create
image environment file. If `offline_yum_registry` is true will directly
install from local repository. (Need prepare local repository first.)

1. Required variables:
   ```
   local_registry: true|false
   offline_yum_registry: true|false
   registry_server: <ip> (required if local_registry is true)
   registry_port: <port> (required if local_registry is true)
   ```
   
2. Play
`ansible-playbook -e "{local_registry: <bool>}" -e "{offline_yum_registry: <bool>}" -e "registry_server=<ip>" -e "registry_port=<port>" ansible/prepare-undercloud.yaml`

## Create local registry images environment file [x]
1. Play
`ansible-playbook -e "{local_registry: true}" -e "registry_server=<server>" -e "registry_port=<port>" -t image-environment ansible/prepare-undercloud.yaml`

# Deploy undercloud workflow
## Scenario 1
Install with Internet
1. Prepare undercloud deploy
2. Edit undercloud.conf at /home/stack
3. Deploy undercloud

## Scenario 2
Deploy without Internet
1. Prepare offline repo
2. Prepare offline registry
3. Prepare undercloud deploy
4. Edit undercloud.conf at /home/stack
5. Deploy undercloud
