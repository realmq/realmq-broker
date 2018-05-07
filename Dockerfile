FROM erlang:19 as adapter_plugin_builder
COPY plugins/adapter /usr/src/plugin
RUN cd /usr/src/plugin && rebar3 compile

FROM debian:jessie

LABEL \
  description="RealMQ Broker" \
  vendor="RealMQ GmbH" \
  version="0.6.0"

# install tools and dependencies
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y curl logrotate sudo gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install vernemq
ENV VMQ_VERSION 1.3.1
RUN curl -sL https://bintray.com/artifact/download/erlio/vernemq/deb/jessie/vernemq_${VMQ_VERSION}-1_amd64.deb -o /tmp/vernemq.deb && \
    dpkg -i /tmp/vernemq.deb && \
    rm /tmp/vernemq.deb

COPY vernemq.default.tpl vernemq.conf.tpl /opt/broker/
COPY run /opt/broker/run
COPY run.sh /
COPY \
  --from=adapter_plugin_builder \
  /usr/src/plugin/_build/default/lib/realmq_adapter \
  /opt/broker/plugins/lib/realmq_adapter

CMD ["/run.sh"]
EXPOSE 1883 44053 8888 8080
