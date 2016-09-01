FROM registry.gitlab.com/gfcc/broker-base:vernemq_develop

COPY adapter.lua /opt/gfcc/broker/scripts/adapter.lua
