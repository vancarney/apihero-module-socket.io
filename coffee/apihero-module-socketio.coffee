# initialized redis
{EventEmitter}    = require 'events'
io_redis          = require 'socket.io-redis'
_io               = require 'socket.io'
io                = null
_listeners        = {}
{_}               = require 'lodash'
connection        = require './client/connection'
emitter           = new EventEmitter
WebSock = {}
WebSock.StreamModel       = require './client/models/stream-model'
WebSock.StreamCollection  = require './client/models/stream-collection'
WebSock.Client            = require './client'

module.exports.WebSock = WebSock

connectionHandler = (client)=>
  for listener of _listeners
    client.removeListener listener, l if client._events? and (l = client._events[listener])? and typeof l is 'function'
    client.on listener, _listeners[listener]
  emitter.emit 'connect', client
  client.on 'disconnect', =>
    emitter.emit 'disconnect', client
       
module.exports.addListeners = addListeners = (listeners)=>
  return throw "listeners required to be type 'object' type was <#{type}>" unless (type = typeof listeners) is 'object'
  _listeners = listeners
  module.exports
module.exports.getIO = => io
module.exports.on = =>
  emitter.addListener.apply emitter, arguments
  module.exports
module.exports.off = =>
  emitter.removeListener.apply emitter, arguments
  module.exports
module.exports.init = (app, options, callback)=>
  opts = _.extend {}, {auto_connect:true, redisHost:'localhost', redisPort:6379, secure:false}, options
  app.on 'started', =>
    unless app.hasOwnProperty 'ApiHero'
      console.log 'APIHero not found\ntry running: npm install --save apihero'
      process.exit 1
    app.ApiHero.proxyEvent 'socket-io-init', emitter
    # intiializes socket.io and defines redis as socket.io adapter
    (io = _io app.ApiHero.server).adapter io_redis {host: opts.redisHost, port: opts.redisPort}
    io.sockets.on 'connect', connectionHandler
    _.extend app.ApiHero, io:io
    emitter.emit 'socket-io-init'
  process.nextTick callback