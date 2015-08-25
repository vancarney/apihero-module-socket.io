unless window?
  Backbone = require 'backbone'
  SockData = require './models/stream-model'
  ApiHero = {WebSock:{}}
  connection = require './connection'
  
class ApiHero.WebSock.Client
  __streamHandlers:{}
  constructor:(@__addr, @__options={})->
    _.extend @, Backbone.Events
    console.log 'ApiHero.WebSock.Client'
    @model = ApiHero.WebSock.StreamModel 
    @connect() unless @__options.auto_connect? and @__options.auto_connect is false
  connect:->
    console.log "connect: #{ApiHero.WebSock.SocketIOConnection}"
    @__conn = new (if connection? then connection else ApiHero.WebSock.SocketIOConnection) @__addr #@__options
    @
  addStream:(name,clazz)->
    return s if (s = @__streamHandlers[name])?
    @__streamHandlers[name] = clazz
    @
  removeStream:(name)->
    return null unless @__streamHandlers[name]?
    delete @__streamHandlers[name]
    @
  getClientId:->
    return null unless @socket?.io?.engine?
    @socket.io.engine.id

unless window?    
  module.exports = ApiHero.WebSock.Client