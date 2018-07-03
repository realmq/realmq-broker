#!/usr/bin/env sh

if [ -z "$GITLAB_CI" -o "$GITLAB_CI" != "true" ]; then
  echo "invalid environment" 1>&2
  exit 1
fi

if [ -z "$CI_COMMIT_REF_NAME" ]; then
  echo "missing CI_COMMIT_REF_NAME" 1>&2
  exit 3
fi

root=$(dirname $0)/..
tag=$(echo $CI_COMMIT_REF_NAME | tr A-Z a-z | sed 's/[^a-z0-9._-]/-/g')
image_name=realmq/realmq-broker
image_ref=$image_name:$tag

set -ex
docker build -t $image_ref "$root"
docker push $image_ref
