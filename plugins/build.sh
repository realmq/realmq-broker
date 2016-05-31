#!/usr/bin/env bash

if [ ! -d /usr/src/vmq_diversity ]; then
  mkdir -p /usr/src/vmq_diversity
fi
if [ -d /usr/src/vmq_diversity/.git ]; then
  git pull
fi
if [ $(find /usr/src/vmq_diversity -maxdepth 0 -type d -empty 2>/dev/null) ]; then
  git clone https://github.com/erlio/vmq_diversity.git /usr/src/vmq_diversity
fi

cd /usr/src/vmq_diversity
git pull
./rebar3 compile
