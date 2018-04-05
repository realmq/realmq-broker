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
- `TLS_CERTFILE` - Path to pem encoded TLS certificate file
- `TLS_KEYFILE` - Path to pem encoded TLS key file
