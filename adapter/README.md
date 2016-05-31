# GFCC Broker Adapter
Endpoints:
- `GET /auth?c=<client_id>&u=<user>&p=<pass>` - validate auth token
- `POST /stat?c=<client_id>` - connection status, `online` or `offline`
- `GET /sub?c=<client_id>&p=<pattern>` - auth subscribe on pattern
- `GET /pub?c=<client_id>&t=<topic>` - auth subscribe on topic
