FROM registry.gitlab.com/gfcc/broker-base:vernemq_develop

COPY run/afterStart/*.sh /opt/broker/run/afterStart/
