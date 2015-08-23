unless window?  
  Backbone = require 'backbone'
  ApiHero = {WebSock:{}}
class ApiHero.WebSock.StreamModel extends Backbone.Model
  header:{}
  initialize:(attributes, options)->
    getFunctionName = (fun)->
      if (n = fun.toString().match /function+\s{1,}([a-zA-Z]{1,}[_0-9a-zA-Z]?)/)? then n[1] else null
    @__type = ((fun)=>
      fun.constructor.name || if (name = getFunctionName fun.constructor)? then name else '__UNDEFINED_CLASSNAME__'
    ) @
    StreamModel.__super__.initialize.call @, attributes, options
  sync: (mtd, mdl, opt={}) ->
    m = {}
    _.extend @header, opt.header if opt.header?
    # Create-operations get routed to Socket.io
    if mtd is 'create'
      # apply Class Name as type if not set by user
      @header.type ?= @__type
      m.header  = _.extend @header, sntTime: Date.now()
      m.body    = mdl.attributes
      StreamModel.__connection__.socket.emit 'ws:datagram', m
  getSenderId:->
    @header.sender_id || null
  getSentTime:->
    @header.sntTime || null
  getServedTime:->
    @header.srvTime || null
  getRecievedTime:->
    @header.rcvTime || null
  getSize:->
    @header.size || null
  setRoomId:(id)->
    @header.room_id = id
  getRoomId:->
    @header.room_id
  parse: (data)->
    @header = Object.freeze data.header
    StreamModel.__super__.parse.call data.body
unless window? 
  module.exports = ApiHero.WebSock.StreamModel