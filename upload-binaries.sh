#!/bin/bash

# release or dev
TAG=$1
# latest or latest-dev (or a specific version)
BINARIES_IMAGE=$2
# passed as komodo variable
KOMODO_VERSION=$3
# passed as komodo variable
KOMODO_GIT_TOKEN=$4

echo "Tag: ${TAG}"
echo "Image: ${BINARIES_IMAGE}"
echo "Version: ${KOMODO_VERSION}"

X86_64_IMAGE=$BINARIES_IMAGE-x86_64
AARCH64_IMAGE=$BINARIES_IMAGE-aarch64

docker pull $X86_64_IMAGE
docker pull $AARCH64_IMAGE

x86_64_id=$(docker create $X86_64_IMAGE sh)
aarch64_id=$(docker create $AARCH64_IMAGE sh)

docker cp $x86_64_id:/periphery ./periphery-x86_64
docker cp $aarch64_id:/periphery ./periphery-aarch64

curl --user mbecker20:$KOMODO_GIT_TOKEN \
    --upload-file ./periphery-x86_64 \
    https://git.komo.do/api/packages/moghtech/generic/periphery/$KOMODO_VERSION-$TAG/periphery-x86_64
curl --user mbecker20:$KOMODO_GIT_TOKEN \
    --upload-file ./periphery-aarch64 \
    https://git.komo.do/api/packages/moghtech/generic/periphery/$KOMODO_VERSION-$TAG/periphery-aarch64

docker container rm $x86_64_id
docker container rm $aarch64_id