{should,expect} = require 'chai'
{_}             = require 'lodash'
global._        = _
global.should   = should
global.expect   = expect


describe 'init app', ->
  @timeout 5000

  before (done)=>
    lt        = require 'loopback-testing'
    server    = require './server/server/server'
    server.on 'ahero-initialized', =>
      global.app = server
      done.apply @, arguments
      
  it 'should have a reference set on Loopback', =>
    expect(app.ApiHero).to.exist