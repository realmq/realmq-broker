'use strict';

const Adapter = require('./index.js');

const adapter = new Adapter();
console.log('starting');
adapter.start(() => {
  console.log('started');
});

function shutdown() {
  console.log('stopping');
  adapter.stop(() => {
    console.log('stopped');
    process.exit();
  });
}

process.once('SIGINT', shutdown);
process.once('SIGTERM', shutdown);
