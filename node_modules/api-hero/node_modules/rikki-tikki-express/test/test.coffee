fs                = require 'fs'
path              = require 'path'
(chai             = require 'chai').should()
global.API        = require 'rikki-tikki'
global.Adapter    = require '../src/ExpressAdapter'
global.app        = (require 'express')()
global.host       = 'localhost'
global.port       = 3000
request           = require 'supertest'

describe 'ExpressAdapter Test Suite', ->
  it 'should be registered', ->
    API.listAdapters().length.should.equal 1
  it 'should initialize', (done)=>
    global.api = new API {adapter:Adapter.use app}
    .on 'open', =>
      done()

    app.listen port, host, =>
      # console.log("server now listening at http://"+host+":"+port);
     
  it 'should have defined a route', (done)=>
    API.addRoute '/test1', 'get', (req,res)->
      res.end JSON.stringify body:'ok'
    request app
    .get '/test1'
    .expect 200
    .end (e, r)=>
      return throw e if e?
      done()

  it 'should allow an API CREATE route', (done)=>
    request app
    .post '/api/1/item'
    .send { name: 'Manny', species: 'cat' }
    .expect 200
    .end (e, res)=>
      return throw e if e?
      done() if (@OBJ_ID = res.body._id)?

  it 'should allow an API READ route', (done)=>
    setTimeout (=>
      request app
      .get "/api/1/item/#{@OBJ_ID}"
      .expect 200
      .end (e, res)=>
        return throw e if e?
        done() if (res.body.name == 'Manny')
    ), 1500
      
  it 'should allow an API UPDATE route', (done)=>
    request app
    .put "/api/1/item/#{@OBJ_ID}"
    .send { name: 'Manuel', species: 'gato' }
    .end (e, res)=>
      return throw e if e?
      done()
      
  it 'should have updated the record', (done)=>
    request app
    .get "/api/1/item/#{@OBJ_ID}"
    .expect 200
    .end (e, res)=>
      return throw e if e?
      done() if (res.body.name == 'Manuel')
         
  it 'should allow an API DELETE route', (done)=>
    request app
    .del "/api/1/item/#{@OBJ_ID}"
    .expect 200, done
    
  it 'should have removed the record', (done)=>
    request app
    .get "/api/1/item/#{@OBJ_ID}"
    .expect 404
    .end (e, res)=>
      return throw e if e?
      done()