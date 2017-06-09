# Broker
Platform MQTT Frontend

## Docker Env Parameter
- `HOST` - tbd
- `ADAPTER_HOST` - tbd
- `ADAPTER_PORT` - tbd
- `CREDENTIALS` - tbd

## Changelog
### next
- upgrade to `broker-base:0.3.0` base image
- ensure `allow_anonymous = on` to ensure `auth_on_register` webhook gets
  called for incomming connections without username
- remove `on_deliver` hook due performance issues
