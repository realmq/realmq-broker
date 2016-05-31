#!/bin/bash
# original source: github.com/gchudnov/docker-tools
pid=0

# SIGTERM -handler
term_handler() {
  if [ $pid -ne 0 ]; then
    echo "stop vernemq"
    vernemq stop
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

# run configuration
set -a
: ${AUTH_ANONYMOUS:=off}
: ${LOG_LEVEL:=info}
: ${GFCC_ADAPTER_HOST:=adapter}
: ${GFCC_ADAPTER_PORT:=80}
cat /etc/vernemq/vernemq.conf.tpl | envsubst '$AUTH_ANONYMOUS $LOG_LEVEL' > /etc/vernemq/vernemq.conf
cat /etc/default/vernemq.tpl | envsubst > /etc/default/vernemq
set +a

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; term_handler' SIGINT
trap 'kill ${!}; term_handler' SIGTERM

# run application
echo "start vernemq"
vernemq start
pid=$(vernemq getpid)

# output logs
tail -f /var/log/vernemq/console.log &
pid_log_console="$!"
tail -f /var/log/vernemq/error.log &
pid_log_error="$!"

# enable plugins
vmq-admin plugin enable -n vmq_diversity -p /opt/vmq_diversity/_build/default
vmq-admin script load path=/opt/gfcc/adapter.lua

# wait indefinetely
while true
do
  tail -f /dev/null & wait ${!}
done
