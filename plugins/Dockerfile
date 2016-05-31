FROM debian:jessie

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y git wget && \
    wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb -O /tmp/erlang-solutions_1.0_all.deb && \
    dpkg -i /tmp/erlang-solutions_1.0_all.deb && \
    rm /tmp/erlang-solutions_1.0_all.deb && \
    apt-get update && \
    apt-get install -y erlang-base erlang-dev erlang-asn1 erlang-eunit erlang-inets erlang-parsetools erlang-public-key erlang-ssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY build.sh /build.sh
CMD ["/build.sh"]
