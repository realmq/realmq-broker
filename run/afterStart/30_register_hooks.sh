#!/usr/bin/env bash
: ${ADAPTER_HOST:=broker-adapter}
: ${ADAPTER_PORT:=8080}

baseUri="http://${ADAPTER_HOST}:${ADAPTER_PORT}"
function register_hook {
  hook=$1
  echo "register web hook: ${hook}"
  vmq-admin webhooks register hook=${hook} endpoint="${baseUri}/vmq/hook"
}

register_hook auth_on_register
register_hook auth_on_subscribe
register_hook auth_on_publish
register_hook on_client_wakeup
register_hook on_client_offline
register_hook on_client_gone
