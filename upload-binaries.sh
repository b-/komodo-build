#!/bin/bash

# release or dev
CHANNEL=$1
# latest or latest-dev (or a specific version)
TAG=$2
# passed as komodo variable
KOMODO_VERSION=$3
# passed as komodo variable
KOMODO_GIT_TOKEN=$4

echo "Channel: ${CHANNEL}"
echo "Tag: ${TAG}"
echo "Version: ${KOMODO_VERSION}"

X86_64_IMAGE=git.komo.do/komodo/binaries:$TAG-x86_64
AARCH64_IMAGE=git.komo.do/komodo/binaries:$TAG-aarch64

docker pull $X86_64_IMAGE
docker pull $AARCH64_IMAGE

x86_64_id=$(docker create $X86_64_IMAGE sh)
aarch64_id=$(docker create $AARCH64_IMAGE sh)

docker cp $x86_64_id:/periphery ./periphery-x86_64
docker cp $aarch64_id:/periphery ./periphery-aarch64

curl --user mbecker20:$KOMODO_GIT_TOKEN \
    --upload-file ./periphery-x86_64 \
    https://git.komo.do/api/packages/komodo/generic/periphery/$KOMODO_VERSION-$CHANNEL/periphery-x86_64
curl --user mbecker20:$KOMODO_GIT_TOKEN \
    --upload-file ./periphery-aarch64 \
    https://git.komo.do/api/packages/komodo/generic/periphery/$KOMODO_VERSION-$CHANNEL/periphery-aarch64

docker container rm $x86_64_id
docker container rm $aarch64_id