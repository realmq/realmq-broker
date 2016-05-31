'use strict';

const http = require('http');
const url = require('url');

class Adapter {
  constructor() {
    this._started = false;
    this._server = null;
  }

  start(done) {
    done = done || (() => {});
    if (!this._server) {
      this._server = this._initServer();
    }
    if (!this._started) {
      this._started = true;
      this._server.listen(8080, done);
    } else {
      process.nexTick(done);
    }
  }

  _initServer() {
    return http.createServer(this._onRequest.bind(this));
  }

  stop(done) {
    done = done || (() => {});
    if (this._started) {
      this._server.close(() => {
        this._started = false;
        done();
      });
    } else {
      process.nextTick(done);
    }
  }

  _onRequest(request, response) {
    const params = url.parse(request.url);
    switch (params.pathname) {
      case '/': this._onInfo(request, response); break;
      case '/ping': this._onPing(request, response); break;
      case '/auth': this._onAuth(request, response); break;
      case '/stat': this._onStat(request, response); break;
      case '/pub': this._onPub(request, response); break;
      case '/sub': this._onSub(request, response); break;
      default:
        response.statusCode = 404;
        response.end();
        break;
    }
  }

  _onInfo(request, response) {
    if (request.method !== 'GET') {
      return this._denyMethod(response, 'GET');
    }
    response.writeHead(200, {'Content-Type': 'text/plain'});
    response.write("gcff/broker - test adapter\n");
    response.end();
  }

  _onPing(request, response) {
    if (request.method !== 'GET') {
      return this._denyMethod(response, 'GET');
    }
    response.writeHead(200, {'Content-Type': 'text/plain'});
    response.write("pong\n");
    response.end();
  }

  _onAuth(request, response) {
    if (request.method !== 'GET') {
      return this._denyMethod(response, 'GET');
    }
    const params = url.parse(request.url, true);
    const clientId = params.query.c;
    const username = params.query.u;
    const password = params.query.p;

    const status = {
      auth: false
    };
    if (clientId === 'dada') {
      status.auth = true;
      status.uid = 'uid-dada';
    }

    response.writeHead(200, {'Content-Type': 'application/json'});
    response.write(JSON.stringify(status) + "\n");
    response.end();
  }

  _onStat(request, response) {
    if (request.method !== 'POST') {
      return this._denyMethod(response, 'POST');
    }
    response.statusCode = 204;
    response.end();
  }

  _onPub(request, response) {
    if (request.method !== 'GET') {
      return this._denyMethod(response, 'GET');
    }
    const params = url.parse(request.url, true);
    const clientId = params.query.c;
    const pattern = params.query.p;

    const status = {
      auth: false
    };

    if (clientId === 'dada' && pattern.indexOf('/test/') === 0) {
      status.auth = true;
    }

    response.writeHead(200, {'Content-Type': 'application/json'});
    response.write(JSON.stringify(status) + "\n");
    response.end();
  }

  _onSub(request, response) {
    if (request.method !== 'GET') {
      return this._denyMethod(response, 'GET');
    }
    response.writeHead(200, {'Content-Type': 'text/plain'});
    response.write("pong\n");
    response.end();
  }

  _denyMethod(response, allowedMethods) {
    if (allowedMethods.join) {
      allowedMethods = allowedMethods.join(',');
    }
    response.writeHead(405, {
      'Content-Type': 'text/plain',
      'Allow': allowedMethods
    });
    response.end();
  }
}

module.exports = Adapter;
