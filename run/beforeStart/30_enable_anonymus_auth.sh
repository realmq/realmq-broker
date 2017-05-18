#!/usr/bin/env bash
sed -i.bak -re 's|allow_anonymous\s*=.*|allow_anonymous = on|' /etc/vernemq/vernemq.conf
