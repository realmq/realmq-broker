# RealMQ Broker - Adapter Plugin
This is the RealMQ Adapter plugin for VerneMQ. For now it houses all erlang
code to connect the broker with the rest of the system.

## Maintenance
**Compile**
```bash
$ docker run --rm -it -v $PWD:/usr/src/plugin -w /usr/src/plugin erlang:19 rebar3 compile
```

**Upgrade dependencies**
```bash
$ docker run --rm -it -v $PWD:/usr/src/plugin -w /usr/src/plugin erlang:19 rebar3 upgrade 
```
