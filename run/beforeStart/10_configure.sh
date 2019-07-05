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
: ${ADAPTER_HOST:=platform}
: ${ADAPTER_PORT:=8080}

: ${TLS_PORT:=8883}
: ${TLS_CAFILE:=/etc/vernemq/cacerts.pem}
: ${TLS_CERTFILE:=/etc/vernemq/cert.pem}
: ${TLS_KEYFILE:=/etc/vernemq/key.pem}
: ${TLS_CIPHERS:=ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256}

# filter out cipher suites not supported by openssl
#TLS_CIPHERS=$(openssl ciphers -s "$TLS_CIPHERS")

function add_tls_file {
    source=$1
    target=$2
    if [[ "$source" != "$target" && -f "$source" ]]; then
        cp "$source" "$target"
        chown root:vernemq "$target"
        chmod 0440 "$target"
    fi
}

add_tls_file "$TLS_CAFILE" "/etc/vernemq/cacerts.pem"
add_tls_file "$TLS_CERTFILE" "/etc/vernemq/cert.pem"
add_tls_file "$TLS_KEYFILE" "/etc/vernemq/key.pem"

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
    $TLS_PORT
    $TLS_CAFILE
    $TLS_CERTFILE
    $TLS_KEYFILE
    $TLS_CIPHERS
  ' > /etc/vernemq/vernemq.conf

cat /opt/broker/vernemq.default.tpl | \
  envsubst '
    $ENVIRONMENT
    $VMQ_VERSION
    $ADAPTER_HOST
    $ADAPTER_PORT
  ' > /etc/default/vernemq
