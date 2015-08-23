# initialized redis
io_redis= require 'socket.io-redis'
io      = require 'socket.io'

connection = require './client/connection'

WebSock = {}
WebSock.StreamModel       = require './models/stream-model'
WebSock.StreamCollection  = require './models/stream-collection'
WebSock.Client            = require './client'

module.exports.WebSock = WebSock
module.exports.init = (app, options, callback)=>
  opts = _.extend {}, {auto_connect:true, redisHost:'localhost', redisPort:6379, secure:false}, options
  server = require(if opts.secure then 'https' else 'http').Server app
  unless app.hasOwnProperty 'APIHero' and typeof app.APIHero is 'object'
    console.log 'APIHero not found\ntry running: npm install --save apihero'
    process.exit 1
  app.APIHero.io = io server
  # defines redis as socket.io adapter
  app.APIHero.io.adapter redis {host: opts.redisHost, port: opts.redisPort}
  process.nextTick callback