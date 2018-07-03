#!/usr/bin/env sh

if [ -z "$GITLAB_CI" -o "$GITLAB_CI" != "true" ]; then
  echo "invalid environment" 1>&2
  exit 1
fi

if [ -z "$CI_COMMIT_REF_NAME" ]; then
  echo "missing CI_COMMIT_REF_NAME" 1>&2
  exit 3
fi

if [ -z "$DOCKER_USER" ]; then
  echo "missing DOCKER_USER" 1>&2
  exit 4
fi

if [ -z "$DOCKER_PASSWORD" ]; then
  echo "missing DOCKER_PASSWORD" 1>&2
  exit 5
fi

root=$(dirname $0)/..
tag=$(echo $CI_COMMIT_REF_NAME | tr A-Z a-z | sed 's/[^a-z0-9._-]/-/g')
image_ref=realmq/realmq-broker:$tag

set -ex
docker build -t $image_ref "$root"
docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
docker push $image_ref
