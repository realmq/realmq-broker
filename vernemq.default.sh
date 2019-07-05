#/usr/bin/env bash
: ${ENVIRONMENT:=production}
: ${VMQ_VERSION:="n/a"}
: ${ADAPTER_HOST:=platform}
: ${ADAPTER_PORT:=8080}

cat <<EOF
# /etc/default/vernemq
export ENVIRONMENT=${ENVIRONMENT}
export VMQ_VERSION=${VMQ_VERSION}
export ADAPTER_HOST=${ADAPTER_HOST}
export ADAPTER_PORT=${ADAPTER_PORT}
EOF
