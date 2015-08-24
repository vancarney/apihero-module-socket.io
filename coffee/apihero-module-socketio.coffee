# initialized redis
io_redis= require 'socket.io-redis'
io      = require 'socket.io'
{_}       = require 'lodash'
connection = require './client/connection'

WebSock = {}
WebSock.StreamModel       = require './client/models/stream-model'
WebSock.StreamCollection  = require './client/models/stream-collection'
WebSock.Client            = require './client'

module.exports.WebSock = WebSock
module.exports.init = (app, options, callback)=>
  opts = _.extend {}, {auto_connect:true, redisHost:'localhost', redisPort:6379, secure:false}, options
  server = require(if opts.secure then 'https' else 'http').Server app
  unless app.hasOwnProperty 'ApiHero'
    console.log 'APIHero not found\ntry running: npm install --save apihero'
    process.exit 1
  io = io server
  # defines redis as socket.io adapter
  io.adapter io_redis {host: opts.redisHost, port: opts.redisPort}
  # _.extend app.APIHero, _io
  process.nextTick callback