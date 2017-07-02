# Broker
Platform MQTT Frontend

## Docker Env Parameter
- `HOST` - IP address to listen on, default: `127.0.0.1`, set to `0.0.0.0` to
  listen on all assigned IP addresses
- `ADAPTER_HOST` - host or IP address of broker-adapter service
- `ADAPTER_PORT` - port of broker-adapter service
- `CREDENTIALS` - set of credentials to connect to broker as system user,
  format: `user:pass [user:pass]...`, so username and password are separated by
  colon and credentials are separated by space

## Changelog
### 0.3.0
- upgrade to VerneMQ version 1.1.0
- merge with `broker-base` image
- remove `on_deliver` hook due performance issues
