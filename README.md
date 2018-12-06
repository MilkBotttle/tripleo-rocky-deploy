# Tripleo Rocky
Ansible playbooks for deploy.

## Requirement
* CentOS 7
* Ansible >= 2.4

# Functions

## Install docker-ce on fresh node
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
Need replace `registry_server`, `registry_port`

1. Play
`ansible-playbook --extra-vars "registry_server=<ip> registry_port=<port>" ansible/check-local-registry.yaml`

## Prepare undercloud deploy
This will install tripleo repo, if offline_yum_repo is true will pull from
local-registry then create image environment file. If offline undercloud set

1. Edit `ansible/environment.yaml`
2. Play
`ansible-playbook -e @ansible/environment.yaml ansible/prepare-undercloud.yaml`

## Create local registry images environment file
1. Play
`ansible-playbook -e --extra-vars "local_registry=true" -t image-environment ansible/prepare-undercloud.yaml`

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
