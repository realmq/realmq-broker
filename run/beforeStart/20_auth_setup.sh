#!/usr/bin/env bash
echo '' > /etc/vernemq/vmq.acl
touch /etc/vernemq/vmq.passwd
for user_pass in $CREDENTIALS
do
  IFS=':' read -r -a parts <<< "${user_pass}"
  echo "user ${parts[0]}" >> /etc/vernemq/vmq.acl
  echo 'topic #' >> /etc/vernemq/vmq.acl
  echo '' >> /etc/vernemq/vmq.acl
  vmq-passwd /etc/vernemq/vmq.passwd "${parts[0]}" <<EOS > /dev/null
${parts[1]}
${parts[1]}
EOS
done
