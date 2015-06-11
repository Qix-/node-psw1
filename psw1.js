'use strict';
/**
 * AUKEY PS-W1 interface
 */

var net = require('net');

function PSW1(ip) {
  if (!(this instanceof PSW1)) {
    return new PSW1(ip);
  }

  if (!ip) {
    throw 'missing IP address';
  }

  this.ip = ip;
  this.sock = null;

  Object.defineProperty(this, '_assertSock', {
    get: function() {
      return function _assertSock() {
        if (!this.sock) {
          throw 'you must connect to the PSW1 before calling this method!';
        }
      }
    }
  });
}

PSW1.prototype = {
  connect: function connect(cb) {
    if (this.sock) {
      cb();
      return;
    }

    this.sock = net.createConnection(2500, this.ip, cb);
  }
};

module.exports = PSW1;
