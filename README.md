# Tripleo Rocky
Ansible playbooks for deploy.

## Requirement
* CentOS 7
* Ansible >= 2.4

## Create tripleo images tarball in registry node
1. Required variables:
   ```
   tripleo_tar_images: Required. Images tarball path. (String)

   ```
2. Play
`ansible-playbook -e "tripleo_tar_images=<path>"ansible/create-registry-images-tarball.yaml`

## Create tripleo container images local registry
This will install docker registry, pull and push images

1. Required variables:
   ```
   registry_server: Required. Registry server bind ip. (String)
   registry_port: Required. Registry server bind port. (Straing)

   ```
2. Play
`ansible-playbook -e "registry_server=<ip>" -e "registry_port=<port> ansible/create-offline-registry.yaml`

## Test local registry is ok [none-test]
This task pull all images from local registry to check.

1. Required variables:
   ```
   registry_server: Required. Default 127.0.0.1. (String)
   registry_port: Required. Default 8787. (Straing)
   ```
2. Play
`ansible-playbook -e "registry_server=<ip> -e "registry_port=<port>" ansible/check-local-registry.yaml`

## Install undercloud and registry server together ( need external network )
This will install undercloud and registry on same node, registry listen on
br-ctlplane, overcloud can pull image from registry.

1. Edit `undercloud.conf` this will merge with template
2. Run playbook to prepare requirement
`ansible-playbook ansible/install-undercloud-and-create-registry.yaml`
3. Install undercloud
```
sudo su - stack
openstack undercloud install
```
## Create local registry images environment file for overcloud
Need tripleo client
Run
`openstack overcloud container image prepare --push-destination <registry-ip:port> --output-env-file <path>`
