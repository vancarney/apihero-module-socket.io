{EventEmitter}  = require 'events'
class ValidationModel extends Backbone.Model
  defaults:
    header:
      sender_id: String
      type: String
      sntTime: Date
      srvTime: Date
      rcvTime: Date
      size: Number
    body:null
  validate:(o)->
    o ?= @attributes
    return "required part 'header' was not defined" unless o.header?
    for key in @defaults.header
      return "required header #{key} was not defined" unless o.header[key]?
    return "wrong value for sender_id header" unless typeof o.header.sender_id is 'string'
    return "wrong value for type header" unless typeof o.header.type is 'string'
    return "wrong value for sntTime header" unless (new Date o.header.sntTime).getTime() is o.header.sntTime
    return "wrong value for srvTime header" unless (new Date o.header.srvTime).getTime() is o.header.srvTime
    return "wrong value for rcvTime header" unless (new Date o.header.rcvTime).getTime() is o.header.rcvTime
    return "required part 'body' was not defined" unless o.body
    return "content size was invalid" unless JSON.stringify o.body is o.size
    return
class SocketIOConnection extends EventEmitter
  constructor:(host, port, @__options)->
    opts =
      multiplex: true
      reconnection: true
      reconnectionDelay: 1000
      reconnectionDelayMax: 5000
      timeout: 20000
    _.extend opts, _.pick( @__options, _.keys opts )
    _socket = io "#{@__addr}", opts
    .on 'ws:datagram', (data)=>
      data.header.rcvTime = Date.now()
      (dM = new ValidationModel).set data
      stream.add dM.attributes if dM.isValid() and (stream = @__streamHandlers[dM.attributes.header.type])?
    .on 'connect', =>
      WebSock.SockData.__connection__ = @
      @trigger 'connect', @
    .on 'disconnect', =>
      @trigger 'disconnect'
    .on 'reconnect', =>
      @trigger 'reconnect'
    .on 'reconnecting', =>
      @trigger 'reconnecting', @
    .on 'reconnect_attempt', =>
      @trigger 'reconnect_attempt', @
    .on 'reconnect_error', =>
      @trigger 'reconnect_error', @
    .on 'reconnect_failed', =>
      @trigger 'reconnect_failed', @
    .on 'error', =>
      @trigger 'error', @
    @getSocket = => _socket