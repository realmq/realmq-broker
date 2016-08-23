#!/usr/bin/env sh
set -e

docker build -t rfcc/broker/plugins_builder ./plugins

mkdir -p build/plugins
mkdir -p build/plugins/vmq_diversity
docker run --rm -v $(pwd)/build/plugins/vmq_diversity:/usr/src/vmq_diversity rfcc/broker/plugins_builder
