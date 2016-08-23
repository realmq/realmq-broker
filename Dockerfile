FROM debian:jessie

# install tools and dependencies
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y curl logrotate sudo gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install vernemq
ENV VMQ_VERSION 0.13.1
RUN curl -sL https://bintray.com/artifact/download/erlio/vernemq/deb/jessie/vernemq_${VMQ_VERSION}-1_amd64.deb -o /tmp/vernemq_${VMQ_VERSION}-1_amd64.deb && \
    dpkg -i /tmp/vernemq_${VMQ_VERSION}-1_amd64.deb && \
    rm /tmp/vernemq_${VMQ_VERSION}-1_amd64.deb

# add vmq_diversity
COPY build/plugins/vmq_diversity /opt/vmq_diversity

COPY vernemq.tpl /etc/default/vernemq.tpl
COPY vernemq.conf.tpl /etc/vernemq/vernemq.conf.tpl
COPY vmq.acl /etc/vernemq/vmq.acl
COPY run.sh /run.sh
COPY adapter.lua /opt/gfcc/broker/adapter.lua

CMD ["/run.sh"]
EXPOSE 1883
