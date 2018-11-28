# Tripleo Rocky
Ansible playbooks for deploy.

## Requirement
* CentOS 7
* Ansible >= 2.4

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
