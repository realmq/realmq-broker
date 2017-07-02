#!/usr/bin/env bash
# original source: github.com/gchudnov/docker-tools
pid=0

# run "before start" scripts
if [ -d /opt/broker/run/beforeStart ]
then
  for file in $(find /opt/broker/run/beforeStart -maxdepth 1 -type f -executable | sort); do
    echo "$file"
    $file
  done
fi

# run application
echo "start vernemq"
vernemq start
pid=$(vernemq getpid)

if [ $? -ne 0 ]
then
  echo "failed to start vernemq" 1>&2
  exit 1
fi

# attach to logs
tail -f /var/log/vernemq/console.log &
pid_log_console="$!"
tail -f /var/log/vernemq/error.log &
pid_log_error="$!"

# run "after start" scripts
if [ -d /opt/broker/run/afterStart ]
then
  for file in $(find /opt/broker/run/afterStart -maxdepth 1 -type f -executable | sort); do
    echo "$file"
    $file
  done
fi

# setup term handler
term_handler() {
  if [ -n "$pid" -a "$pid" != "0" ]; then
    echo "stop vernemq"
    vernemq stop
  fi
  exit 143 # 128 + 15 -- SIGTERM
}
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; term_handler' SIGINT
trap 'kill ${!}; term_handler' SIGTERM

# wait indefinetely
while true
do
  tail -f /dev/null & wait ${!}
done
