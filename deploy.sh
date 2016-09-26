#!/bin/bash -e

. VERSION

docker tag rails4-onbuild $DOCKER_TAG:latest
docker push $DOCKER_TAG:latest

if ! docker pull $DOCKER_TAG:$VERSION; then
  echo "Releasing new version: $VERSION"
  docker tag rails4-onbuild $DOCKER_TAG:$VERSION
  docker push $DOCKER_TAG:$VERSION

else
  echo "Not overwriting existing version: $VERSION"
fi
