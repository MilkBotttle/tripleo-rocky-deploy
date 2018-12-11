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

## Create tripleo images local-registry by tarball image
This will install docker registry, move images to registry, config firewall.

1. Required variables:
   ```
   registry_server: Required. Registry server bind ip. Default 127.0.0.1.(String)
   registry_port: Required. Registry server bind port. Default 8787 (Straing)
   tripleo_tar_images: Required. Images tarball path. (String)

   ```
2. Play
`ansible-playbook -e "registry_server=<ip>" -e "registry_port=<port> -e "tripleo_tar_images=<path>" ansible/create-offline-registry.yaml`

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
2. Run
`ansible-playbook ansible/install-undercloud-and-create-registry.yaml`

## Create local registry images environment file for overcloud
Need tripleo client
Run
`openstack overcloud container image prepare --push-destination <registry-ip:port> --output-env-file <path>`
---
# Manually Use openstack tripleo client install
## Create local registry

1. Install python-tripleoclient
1. Create default env file
`openstack tripleo container image prepare default --output-env-file prepare-default.yaml`
2. Edit prepare-default.yaml `push_destination: <addr:port>`
3. Pull and push
`openstack tripleo container image prepare -e prepare-default.yaml --output-env-file image-prepared.yaml`

## Deploy undercloud with local registry (need external network)
This will create local registry listen on br-ctlplane
1. Create `stack` user with 
1. Create env file
`openstack tripleo container image prepare default --output-env-file prepare-default.yaml`
1. Edit undercloud.conf add config under [Default] custom_env_files=<env-file-path>
2. Install undercloud
`openstack undercloud install`

## Deploy undercloud only

## Prepare overcloud images environemnt file
1. `openstack overcloud container image prepare --push-destination <addr:port> --output-env-file 01-overcloud-container-images.yaml`
