FROM registry.gitlab.com/gfcc/broker-base:vernemq_0.2.0

LABEL \
  description="GFCC Broker" \
  version="0.2.1"

COPY run/afterStart/*.sh /opt/broker/run/afterStart/
