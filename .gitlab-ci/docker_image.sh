#!/usr/bin/env sh

if [ -z "$GITLAB_CI" -o "$GITLAB_CI" != "true" ]; then
  echo "invalid environment" 1>&2
  exit 1
fi

if [ -z "$CI_REGISTRY_IMAGE" ]; then
  echo "missing CI_REGISTRY_IMAGE" 1>&2
  exit 2
fi

if [ -z "$CI_COMMIT_REF_NAME" ]; then
  echo "missing CI_COMMIT_REF_NAME" 1>&2
  exit 3
fi

root=$(dirname $0)/..
tag=$(echo $CI_COMMIT_REF_NAME | tr A-Z a-z | sed 's/[^a-z0-9._-]/-/g')
image_ref=$CI_REGISTRY_IMAGE:$tag

set -ex
docker build -t $image_ref "$root"
docker login -u gitlab-ci-token -p $CI_JOB_TOKEN registry.gitlab.com
docker push $image_ref
