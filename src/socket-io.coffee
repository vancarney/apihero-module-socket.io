WebSock = global.WebSock ?= {}

class WebSock.Client
  __streamHandlers:{}
  constructor:(@__addr, @__options={})->
    _.extend @, Backbone.Events
    @model = WebSock.SockData 
    @connect() unless @__options.auto_connect? and @__options.auto_connect is false
  connect:->
    @
  addStream:(name,clazz)->
    return s if (s = @__streamHandlers[name])?
    @__streamHandlers[name] = clazz
  removeStream:(name)->
    return null unless @__streamHandlers[name]?
    delete @__streamHandlers[name]
  getClientId:->
    return null unless @socket?.io?.engine?
    @socket.io.engine.id 

module.exports.init = (app)=>
  server = require('http').Server app
  app.APIHero = {} unless app.APIHero?
  app.APIHero.io = require('socket.io') server
  # try
    # server.listen app.get 'port'
  # catch e
    # process.nextTick (->)
    # no-op