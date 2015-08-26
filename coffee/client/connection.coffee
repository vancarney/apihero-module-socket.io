unless window?
  Backbone = require 'backbone'
  ApiHero = {WebSock:{}}
class ApiHero.WebSock.ValidationModel extends Backbone.Model
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
class ApiHero.WebSock.SocketIOConnection
  defaults:
    multiplex: true
    reconnection: true
    reconnectionDelay: 1000
    reconnectionDelayMax: 5000
    timeout: 20000
  constructor:(delegate, @__options)->
    _.extend @, Backbone.Events
    if ((url = @__options.url) == null)
      return throw "options.url was null or not defined"
    opts = _.extend {}, @defaults, _.pick( @__options, _.keys @defaults )
    _socket = io url, opts
    .on 'ws:datagram', (data)=>
      data.header.rcvTime = Date.now()
      (dM = new @validator).set data
      stream.add dM.attributes if dM.isValid() and (stream = delegate.__streamHandlers[dM.attributes.header.type])?
    .on 'connect', =>
      ApiHero.WebSock.utils.getClientNS().StreamModel.__connection__ = @
      delegate.trigger 'connect', delegate
    .on 'disconnect', =>
      delegate.trigger 'disconnect'
    .on 'reconnect', =>
      delegate.trigger 'reconnect'
    .on 'reconnecting', =>
      delegate.trigger 'reconnecting', delegate
    .on 'reconnect_attempt', =>
      delegate.trigger 'reconnect_attempt', delegate
    .on 'reconnect_error', =>
      delegate.trigger 'reconnect_error', delegate
    .on 'reconnect_failed', =>
      delegate.trigger 'reconnect_failed', delegate
    .on 'error', =>
      delegate.trigger 'error', @
    @getSocket = => _socket
    @emit = (name, message)=>
      console.log arguments
      console.log delegate.__streamHandlers
      _socket.emit name, message
ApiHero.WebSock.SocketIOConnection::validator = ApiHero.WebSock.ValidationModel
unless window?
  module.exports = ApiHero.WebSock.SocketIOConnection