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
    console.log(`${request.method} ${request.url}`);
    const params = url.parse(request.url);
    switch (params.pathname) {
      case '/': this._onInfo(request, response); break;
      case '/ping': this._onPing(request, response); break;
      case '/auth': this._onAuth(request, response); break;
      case '/status': this._onStatus(request, response); break;
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
    const cid = params.query.c;
    const username = params.query.u;
    const password = params.query.p;

    const status = {
      auth: false
    };
    if (cid === 'dada' || cid.indexOf('dada-') === 0) {
      status.auth = true;
      status.uid = 'uid-dada';
    }

    response.writeHead(200, {'Content-Type': 'application/json'});
    response.write(JSON.stringify(status) + "\n");
    response.end();
  }

  _onStatus(request, response) {
    if (request.method !== 'POST') {
      return this._denyMethod(response, 'POST');
    }

    if (request.headers['content-type'] !== 'application/json') {
      console.log('invalid content-type header: ' + request.headers['content-type']);
      return this._denyContentType(response, 'application/json');
    }

    const params = url.parse(request.url, true);
    const cid = params.query.c;
    const uid = params.query.u;

    if (!cid && !uid) {
      console.log('400 - missing param');
      response.statusCode = 400;
      response.end();
      return;
    }

    var body = '';
    request.on('data', data => body += data);
    request.on('end', () => {
      console.log('body: ' + body);
      var data;
      try {
        data = JSON.parse(body);
      } catch (e) {
        console.log('json parse error: ' + body);
        return this._denyContentType(response, 'application/json');
      }
      if (!data || data.status !== 'online' && data.status !== 'offline') {
        console.log('400 - missing json data');
        response.statusCode = 400;
        response.end();
        return;
      }

      console.log(`user ${uid} with client ${cid} is ${data.status}`);

      response.statusCode = 204;
      response.end();
    });
  }

  _onPub(request, response) {
    if (request.method !== 'GET') {
      return this._denyMethod(response, 'GET');
    }
    const params = url.parse(request.url, true);
    const clientId = params.query.c;
    const userId = params.query.u;
    const topic = params.query.t;

    const status = {
      auth: false
    };

    if (topic.indexOf('test/') === 0) {
      status.auth = true;
    }

    response.writeHead(200, {'Content-Type': 'application/json'});
    response.write(JSON.stringify(status) + "\n");
    response.end();
  }

  _onSub(request, response) {
    if (request.method !== 'POST') {
      return this._denyMethod(response, 'POST');
    }
    if (request.headers['content-type'] != 'application/json') {
      return this._denyContentType(response, 'application/json');
    }

    const params = url.parse(request.url, true);
    const cid = params.query.c;
    const uid = params.query.u;

    if (!cid && !uid) {
      console.log('400 - missing param');
      response.statusCode = 400;
      response.end();
      return;
    }

    var body = '';
    request.on('data', data => body += data);
    request.on('end', () => {
      console.log('body: ' + body);
      var data;
      try {
        data = JSON.parse(body);
      } catch (e) {
        console.log('json parse error: ' + body);
        return this._denyContentType(response, 'application/json');
      }
      if (!data || !data.subscriptions) {
        console.log('400 - missing json data');
        response.statusCode = 400;
        response.end();
        return;
      }

      const subscriptions = {};
      for (var pattern in data.subscriptions) {
        if (pattern.indexOf('test/') === 0) {
          subscriptions[pattern] = data.subscriptions[pattern];
        } else {
          subscriptions[pattern] = false;
        }
      }

      const status = {
        auth: true,
        subscriptions: subscriptions
      };
      response.writeHead(200, {'Content-Type': 'application/json'});
      response.write(JSON.stringify(status) + "\n");
      response.end();
    });
  }

  _denyMethod(response, allowedMethods) {
    console.log('405 - deny method');
    if (allowedMethods.join) {
      allowedMethods = allowedMethods.join(',');
    }
    response.writeHead(405, {
      'Allow': allowedMethods
    });
    response.end();
  }

  _denyContentType(response, allowedContentTypes) {
    console.log('415 - deny content type');
    if (allowedContentTypes.join) {
      allowedContentTypes = allowedContentTypes.join(',');
    }
    response.writeHead(415, {
      'Accept': allowedContentTypes
    });
    response.end();
  }
}

module.exports = Adapter;
