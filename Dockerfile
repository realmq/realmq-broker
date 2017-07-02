FROM debian:jessie

LABEL \
  description="GFCC Broker" \
  version="0.3.0"

# install tools and dependencies
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y curl logrotate sudo gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install vernemq
ENV VMQ_VERSION 1.1.0
RUN curl -sL https://bintray.com/artifact/download/erlio/vernemq/deb/jessie/vernemq_${VMQ_VERSION}-1_amd64.deb -o /tmp/vernemq.deb && \
    dpkg -i /tmp/vernemq.deb && \
    rm /tmp/vernemq.deb

COPY default.tpl /etc/default/
COPY vernemq.conf.tpl /etc/vernemq/
COPY run /opt/broker/run
COPY run.sh /

CMD ["/run.sh"]
EXPOSE 1883 44053 8888 8080
