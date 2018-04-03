#!/usr/bin/env bash
set -a
: ${ENVIRONMENT:=production}
: ${NODE_NAME:="VerneMQ@127.0.0.1"}
: ${AUTH_ANONYMOUS:=off}
: ${LOG_LEVEL:=info}
: ${MAX_CLIENT_ID_SIZE:=345} # 256 * 1.333 = 341,248 -> 345
: ${HOST:=127.0.0.1}
: ${PORT:=1883}
: ${WS_PORT:=8080}
: ${ADAPTER_HOST:=broker-adapter}
: ${ADAPTER_PORT:=8080}

cat /opt/broker/vernemq.conf.tpl | \
  envsubst '
    $NODE_NAME
    $AUTH_ANONYMOUS
    $LOG_LEVEL
    $MAX_CLIENT_ID_SIZE
    $HOST
    $PORT
    $WS_PORT
    $ADAPTER_HOST
    $ADAPTER_PORT
  ' > /etc/vernemq/vernemq.conf

cat /opt/broker/vernemq.default.tpl | \
  envsubst '
    $ENVIRONMENT
    $VMQ_VERSION
    $ADAPTER_HOST
    $ADAPTER_PORT
  ' > /etc/default/vernemq
