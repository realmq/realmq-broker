FROM registry.gitlab.com/gfcc/broker-base:vernemq_develop

LABEL \
  description="GFCC Broker" \
  version="0.2.0"

COPY run/afterStart/*.sh /opt/broker/run/afterStart/
