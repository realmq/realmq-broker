FROM registry.gitlab.com/gfcc/broker-base:0.2.0

LABEL \
  description="GFCC Broker" \
  version="0.2.0"

COPY run/afterStart/*.sh /opt/broker/run/afterStart/
