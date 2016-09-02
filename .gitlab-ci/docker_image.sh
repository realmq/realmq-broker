#!/usr/bin/env sh

if [ -z "$GITLAB_CI" -o "$GITLAB_CI" != "true" ]; then
  echo "invalid environment" 1>&2
  exit 1
fi

if [ -z "$CI_REGISTRY_IMAGE" ]; then
  echo "missing CI_REGISTRY_IMAGE" 1>&2
  exit 2
fi

if [ -z "$CI_BUILD_REF_NAME" ]; then
  echo "missing CI_BUILD_REF_NAME" 1>&2
  exit 3
fi

root=$(dirname $0)/..
image_ref=$CI_REGISTRY_IMAGE:$(echo $CI_BUILD_REF_NAME | sed -r 's/[^a-zA-Z0-9_-]/-/g')

set -ex
docker build -t $image_ref "$root"
docker push $image_ref
