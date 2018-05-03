#!/usr/bin/env bash
: ${ADAPTER_HOST:=broker-adapter}
: ${ADAPTER_PORT:=8080}
: ${ADAPTER_BASEURI:="http://${ADAPTER_HOST}:${ADAPTER_PORT}"}

function vmq_register_webhook {
  hook=$1
  echo "register webhook: ${hook}"
  vmq-admin webhooks register hook=${hook} endpoint="${ADAPTER_BASEURI}/vmq/hook"
}

# enable webhooks plugin
vmq-admin plugin enable --name vmq_webhooks
# register hooks
vmq_register_webhook auth_on_register
vmq_register_webhook auth_on_subscribe
vmq_register_webhook auth_on_publish
#vmq_register_webhook on_deliver
vmq_register_webhook on_client_wakeup
vmq_register_webhook on_client_offline
vmq_register_webhook on_client_gone
