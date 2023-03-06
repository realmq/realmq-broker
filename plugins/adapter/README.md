# RealMQ Broker - Adapter Plugin
This is the RealMQ Adapter plugin for VerneMQ. For now it houses all erlang
code to connect the broker with the rest of the system.

## Maintenance
**Compile**
```bash
$ docker run --rm -it -v $PWD:/usr/src/plugin -w /usr/src/plugin erlang:24 rebar3 compile
```

**Testing**
```bash
$ docker run --rm -it -v $PWD:/usr/src/plugin -w /usr/src/plugin erlang:24 rebar3 enuit
```

**Upgrade dependencies**
```bash
$ docker run --rm -it -v $PWD:/usr/src/plugin -w /usr/src/plugin erlang:24 rebar3 upgrade 
```
