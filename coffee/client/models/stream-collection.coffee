unless window?
  Backbone    = require 'backbone'
  ApiHero = {WebSock:{}}
  ApiHero.WebSock.StreamModel = require './stream-model'
class ApiHero.WebSock.StreamCollection extends Backbone.Collection
  model:ApiHero.WebSock.StreamModel
  fetch:->
    # not implemented
    console.log "StreamModel::fetch is not allowed"
    return false
  sync:()-> 
    # not implemented
    console.log "StreamModel::sync is not allowed"
    return false
  _prepareModel: (attrs,options)->
    if attrs instanceof Backbone.Model
      attrs.collection = @ unless attrs.collection
      return attrs
    options = if options then _.clone options else {}
    options.collection = @
    model = new @model attrs.body, options
    model.header = Object.freeze attrs.header
    return model unless model.validationError
    @trigger 'invalid', @, model.validationError, options
    false
  send:(data)->
    @create data
  initialize:->
    _client = arguments[0] if arguments[0] instanceof ApiHero.WebSock.Client
unless window?
  module.exports = ApiHero.WebSock.StreamCollection