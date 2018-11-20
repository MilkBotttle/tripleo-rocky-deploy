#!/bin/bash

# the Docker Hub V2 API
# Returns all imagas and tags associated with a Docker Hub user account.
# Requires 'jq': https://stedolan.github.io/jq/

# set username and password
UNAME="cameroninwinstack"
UPASS="cameroninwin888"
TRIPLEOREPO="tripleorocky"
IMAGE_TAG="current-tripleo"
# -------

set -e
# aquire token
echo "Acquire token ..."
echo

TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${UNAME}'", "password": "'${UPASS}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)

# get list of repositories for the user account
echo "Get ${TRIPLEOREPO} repo list ..."
REPO_LIST=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/${TRIPLEOREPO}/?page_size=200&q=${TRIPLEOREPO}%2Fcentos-binary-)
REPO_LIST=`echo $REPO_LIST | jq -r '.results|.[]|.name' | grep ^centos-binary`
echo $REPO_LIST
echo

# build a list of all images & tags
echo "Bulid a list of all images & tag ..."
for i in ${REPO_LIST}
do
  # build a list of images from tags
  FULL_IMAGE_LIST="${FULL_IMAGE_LIST} ${TRIPLEOREPO}/${i}:${IMAGE_TAG}"
done

echo "Pull image in list ..."
# output
for i in ${FULL_IMAGE_LIST}
do
  echo "Pulling image ${i} ..."
  docker pull ${i}
done
