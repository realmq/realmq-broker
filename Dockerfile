FROM registry.gitlab.com/gfcc/broker-base:vernemq_0.3.0

LABEL \
  description="GFCC Broker" \
  version="0.2.1"

COPY run/beforeStart/*.sh /opt/broker/run/beforeStart/
COPY run/afterStart/*.sh /opt/broker/run/afterStart/
