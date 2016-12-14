#!/usr/bin/env bash
: ${ADAPTER_HOST:=broker-adapter}
: ${ADAPTER_PORT:=80}

baseUri="http://${ADAPTER_HOST}:${ADAPTER_PORT}"
vmq-admin webhooks register hook=auth_on_register endpoint="${baseUri}/vernemq/auth_on_register"
vmq-admin webhooks register hook=auth_on_subscribe endpoint="${baseUri}/vernemq/auth_on_subscribe"
vmq-admin webhooks register hook=auth_on_publish endpoint="${baseUri}/vernemq/auth_on_publish"
vmq-admin webhooks register hook=on_deliver endpoint="${baseUri}/vernemq/on_deliver"
vmq-admin webhooks register hook=on_client_wakeup endpoint="${baseUri}/vernemq/on_client_wakeup"
vmq-admin webhooks register hook=on_client_offline endpoint="${baseUri}/vernemq/on_client_offline"
vmq-admin webhooks register hook=on_client_gone endpoint="${baseUri}/vernemq/on_client_gone"
