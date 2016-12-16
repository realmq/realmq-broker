FROM registry.gitlab.com/gfcc/broker-base:develop

COPY run/afterStart/*.sh /opt/broker/run/afterStart/
