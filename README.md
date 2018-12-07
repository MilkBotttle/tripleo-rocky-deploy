# Tripleo Rocky
Ansible playbooks for deploy.

## Requirement
* CentOS 7
* Ansible >= 2.4

# Functions

## Install docker-ce on fresh node [x]
This docker-ce version confict with tripleo-repo because this version newer
than tripleo-repo. If you want to put offline yum repo and docker-registry
together just play prepare undercloud tripleo-repo will setup docker at install.

1. Play
`ansible-playbook ansible/install-docker-ce.yaml`

## Prepare offline image tarball
This will install docker registry, pull images from docker hub, push to registry.

1. Required variables:
   ```
   registry_server: Required. Registry server bind ip. Default 127.0.0.1.(String)
   registry_port: Required. Registry server bind port. Default 8787 (Straing)

   ```
2. Play 
`ansible-playbook -e "registry_server=<ip>" -e "registry_port=<port>" ansible/create-tripleo-images-registry.yaml`

## Create image tarball at registry node [x]
1. Required variables:
   ```
   tripleo_tar_images: Required. Images tarball path. (String)

   ```
2. Play
`ansible-playbook -e "tripleo_tar_images=<path>"ansible/create-registry-images-tarball.yaml`

## Create offline registry by tarball image
This will install docker registry, move images to registry, config firewall.

1. Required variables:
   ```
   registry_server: Required. Registry server bind ip. Default 127.0.0.1.(String)
   registry_port: Required. Registry server bind port. Default 8787 (Straing)
   tripleo_tar_images: Required. Images tarball path. (String)

   ```
2. Play
`ansible-playbook -e "registry_server=<ip>" -e "registry_port=<port> -e "tripleo_tar_images=<path>" ansible/create-offline-registry.yaml`

## Test local registry is ok [x]
This task pull all images from local registry to check.

1. Required variables:
   ```
   registry_server: Required. Default 127.0.0.1. (String)
   registry_port: Required. Default 8787. (Straing)
   ```
2. Play
`ansible-playbook -e "registry_server=<ip> -e "registry_port=<port>" ansible/check-local-registry.yaml`

## Prepare undercloud deploy [x]
This will install tripleo repo. If `local_registry` is `true` will create
image environment file. If `offline_yum_registry` is `true` will directly
install from local repository. (Need prepare local repository first.)

1. Required variables:
   ```
   stack_user_password: Optional. Update user "stack" password only on create. Default is "password".(String)
   local_registry: Required. Default false.(Blooean)
   offline_yum_registry: Required. Default false.(Blooean)
   registry_server: Required. If local_registry is true. Default 127.0.0.1. (String)
   registry_port: Required. If local_registry is true. Default 8787. (Straing)
   external_ceph: Optional. If need install ceph. Default false (Blooean)
   ```
2. Play
`ansible-playbook -e "{local_registry: <bool>}" -e "{offline_yum_registry: <bool>}" -e "registry_server=<ip>" -e "registry_port=<port>" ansible/prepare-undercloud.yaml`

## Create local registry images environment file [x]
1. Required variables:
   ```
   local_registry: Required. Set to true.
   registry_server: Required. Default 127.0.0.1. (String)
   registry_port: Required. Default 8787. (Straing)
   ```
   Tag: image-environment

2. Play
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

#Cameron TODO
- split  `Prepare offline image tarball` to create local registry and tarball
- clitool
