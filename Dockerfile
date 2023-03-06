FROM erlang:24 as adapter_plugin_builder
COPY plugins/adapter /usr/src/plugin
RUN cd /usr/src/plugin && rebar3 compile

FROM debian:bullseye

LABEL \
  description="RealMQ Broker" \
  vendor="RealMQ GmbH" \
  version="0.7.1"

# install tools and dependencies
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y curl logrotate sudo libsnappy-dev systemctl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install vernemq
ENV VMQ_VERSION 1.12.6.2
RUN curl -sL https://github.com/vernemq/vernemq/releases/download/${VMQ_VERSION}/vernemq-${VMQ_VERSION}.bullseye.x86_64.deb -o /tmp/vernemq.deb && \
    dpkg -i /tmp/vernemq.deb && \
    rm /tmp/vernemq.deb

COPY vernemq.default.sh vernemq.conf.sh /opt/broker/
COPY run /opt/broker/run
COPY run.sh /
COPY \
  --from=adapter_plugin_builder \
  /usr/src/plugin/_build/default/lib/realmq_adapter \
  /opt/broker/plugins/lib/realmq_adapter

CMD ["/run.sh"]
EXPOSE 1883 8883 8888 44053
