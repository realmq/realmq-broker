# Broker
Platform MQTT Frontend

## Changelog
### next
- upgrade to `broker-base:0.3.0` base image
- ensure `allow_anonymous = on` to ensure `auth_on_register` webhook gets
  called for incomming connections without username
