'use strict';

var PSW1 = require('./psw1');

var ps = new PSW1(process.argv[2]);
ps.connect(function() {
  console.log('connected to scanner at', process.argv[2]);
});
