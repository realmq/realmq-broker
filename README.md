# RealMQ Broker
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Frealmq%2Frealmq-broker.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Frealmq%2Frealmq-broker?ref=badge_shield)

Platform MQTT Frontend

## Docker Env Parameter
- `HOST` - IP address to listen on, default: `127.0.0.1`, set to `0.0.0.0` to
  listen on all assigned IP addresses
- `ADAPTER_HOST` - host or IP address of adapter service
- `ADAPTER_PORT` - port of adapter service
- `ADAPTER_KEY` - api key of adapter service
- `CREDENTIALS` - set of credentials to connect to broker as system user,
  format: `user:pass [user:pass]...`, so username and password are separated by
  colon and credentials are separated by space
- `TLS_ENABLED` - TLS support enabled (`1`) or not (`0`) (default enabled)
- `TLS_CERTFILE` - Path to pem encoded TLS certificate file
- `TLS_KEYFILE` - Path to pem encoded TLS key file


## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Frealmq%2Frealmq-broker.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Frealmq%2Frealmq-broker?ref=badge_large)
