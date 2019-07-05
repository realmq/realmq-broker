#!/usr/bin/env bash
/opt/broker/vernemq.conf.sh > /etc/vernemq/vernemq.conf
/opt/broker/vernemq.default.sh > /etc/default/vernemq
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

