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
: ${GFCC_ADAPTER_USER:=gfcc-adapter}
: ${GFCC_ADAPTER_PASS:=gfcc-adapter}
: ${ENVIRONMENT:=development}
cat /etc/vernemq/vernemq.conf.tpl | envsubst '$AUTH_ANONYMOUS $LOG_LEVEL' > /etc/vernemq/vernemq.conf
cat /etc/default/vernemq.tpl | envsubst > /etc/default/vernemq

case "$ENVIRONMENT" in
  development)
    # user: gfcc-broker-adapter
    # pass: gfcc-broker-adapter
    echo 'gfcc-broker-adapter:$6$VYzKUkOh8pFptqr8$HP6meeGp/Rk0Lcnz2cNT1cJk5uHFK7eff7TRTyyUSy5Tj7MdPHPPU2HUaOFXN6JsZhys34A+vUDDqWTuidc4Dg==' > /etc/vernemq/vmq.passwd
    ;;
  production)
    # user: gfcc-broker-adapter
    # pass: that's a secret ;)
    echo 'gfcc-broker-adapter:$6$L37a05MtNnFwm/Hn$lkyXBknk9ix8+RoXCki5B+kGFOLvEWlXAHj/Fy1H2iOWh7hMrKIvRlwSa5c+EPqp/6UpMUXgIWR/UDQvMx6vaA==' > /etc/vernemq/vmq.passwd
    ;;
  *)
    echo "invalid ENVIRONMENT: $ENVIRONMENT" 1>&2
    exit 1
    ;;
esac

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

# configure plugins
#vmq-admin plugin disable -n vmq_acl
vmq-admin plugin enable -n vmq_diversity -p /opt/vmq_diversity/_build/default
vmq-admin script load path=/opt/gfcc/broker/adapter.lua

# wait indefinetely
while true
do
  tail -f /dev/null & wait ${!}
done
