
net = require 'net'
xml2js = require 'xml2js'
gm = require 'gm'
tmp = require 'tmp'
fs = require 'fs'
EventEmitter = (require 'events').EventEmitter

module.exports = class PSW1 extends EventEmitter
  constructor: (@host, @port = 2500)->
    @sock = null
    @mode = 'offline'
    @debug = false
    # The scanner goes really fast. The emitter will bark at us
    # for a potential memory leak if we don't set this higher.
    #
    # If you're still seeing the error (i.e. you're scanning really
    # long documents), bump this number up even higher.
    @setMaxListeners 100

  connect: ->
    @sock = net.createConnection @port, @host, =>
      @_log '(re) connected to scanner at', @host, 'via port', @port
      @mode = 'init'
    @sock.on 'data', (buf)=>
      @process buf
      @emit 'raw', buf
    @sock.on 'error', (err)=>
      @_log 'ERROR:', err
    @queued = no

  close: ->
    @sock.close()
    @_log 'closed connection to scanner at', @host

  process: (buf)->
#    console.log '\x1b[30;1m' + (require('hexy').hexy buf) + '\x1b[0m'
    bufStr = buf.toString()

    switch @mode
      when 'init'
        xml2js.parseString bufStr, (err, config)=>
          if err then throw err
          @config = config
        @mode = 'ready'
        @scan =
          len: 0
          count: 0
          total: parseInt len
          image: gm 0, 0, '#ffffffff'
          dir: tmp.dirSync()
          buf: new Buffer 0

        @sock.on 'close', =>
          @scan.image.write process.argv[3], (err)->
            if err then throw err
            try
              for i in [0..@scan.count]
                fs.unlinkSync "#{@scan.dir.name}/i#{i}.jpg"
              @scan.dir.removeCallback()
      when 'ready'
        matches = bufStr.match /^\[JpegFrame\]\[(\d+)\]/
        if matches
          len = parseInt matches[1]
          console.log '\x1b[31m' + bufStr + '\x1b[0m'
          @_log 'receiving jpeg, length:', len
          @scan.len = 0
          @scan.total = len
          @_queueReconnect()
          buf = buf.slice matches[0].length

        if buf.length
          @scan.len += buf.length
          @_log 'scan (' + @scan.count + '):',
            ((((@scan.len / @scan.total)*100).toFixed(2)) + '%')

          @scan.buf = Buffer.concat [@scan.buf, buf]

          if @scan.len is @scan.total
            @scan.count++
            @_appendBuffer @scan.buf
            @scan.buf = new Buffer 0
      else
        throw 'unknown scanner state'

  _queueReconnect: ->
    if not @queued
      @sock.once 'close', (err)=>
        if err
          @_log 'WARNING: socket was closed due to an error'
        @connect()
      @queued = yes

  _appendBuffer: (buf)->
    # This is because GM doesn't support .append(Buffer).
    dir = @scan.dir.name
    name = "#{dir}/i#{@scan.count}.jpg"
    fs.writeFileSync name, buf
    @scan.image.append name

  _log: (strs...)->
    if @debug
      console.log.apply console, ['[PS-W1]'].concat strs
