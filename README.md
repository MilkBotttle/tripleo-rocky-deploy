# Tripleo Rocky
Ansible playbooks for deploy.

## Requirement
* CentOS 7
* Ansible >= 2.4

# Functions
## Prepare offline image tarball
This will install docker registry, pull images from docker hub and archive
registry convience move to other node.

1. If you have not installed docker play 
   `ansible-playbook ansible/install-docker-ce.yaml` install lasted docker.
2. Edit environment file `ansible/environment.yaml`
3. Play 
`ansible-playbook -e @ansible/environment.yaml ansible/create-tripleo-images-registry-tarball.yaml`

## Prepare offline registry
This will install docker registry, move images to registry.

1. Edit environment file `ansible/environment.yaml`
2. Play
`ansible-playbook -e @ansible/environment.yaml ansible/create-offline-registry.yaml`

## Prepare undercloud deploy
1. Play
`ansible-playbook ansible/prepare-undercloud.yaml`
2. Edit undercloud.conf at /home/stack

## Generate undercloud offline registry image environment file
1. Play
`ansible-playbook -e @ansible/environment.yaml -t image-environment ansible/prepare-undercloud.yaml
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
