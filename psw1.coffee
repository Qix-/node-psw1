
net = require 'net'
EventEmitter = (require 'events').EventEmitter

module.exports = class PSW1 extends EventEmitter
  constructor: (@host, @port = 2500)->
    @sock = null

  connect: ->
    @sock = net.createConnection @port, @host, =>
      @emit 'connect'
    @sock.on 'data', (buf)=>
      @process buf
      @emit 'raw', buf

  process: (buf)->
    
