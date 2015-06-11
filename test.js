'use strict';

var fs = require('fs');
var path = require('path');
var PSW1 = require('./psw1');

var count = 0;

var ps = new PSW1(process.argv[2]);
ps.debug = true;
ps.on('scan', function(buf) {
  if (!process.argv[3]) {
    console.warn('WARNING: you didn\'t pass a target directory. Ignoring scan');
    return;
  }
  var filename = 'scan_' + count++ + '.jpg';
  fs.writeFileSync(path.join(process.argv[3], filename), buf);
  console.log('\x1b[35mScanned to:\x1b[0m', filename);
});
ps.on('error', function(err) {
  console.warn('ERR:', err);
});
ps.connect();
