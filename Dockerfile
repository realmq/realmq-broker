FROM registry.gitlab.com/gfcc/broker-base:vernemq_develop

COPY scripts/*.lua /opt/gfcc/broker/scripts/
