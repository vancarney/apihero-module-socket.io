class ExpressAdapter
  required:['app']
  constructor:(@params)->
  addRoute:(route, method, handler)->
    @params.app[method]? route, handler || @responseHandler
  responseHandler:(res, data, headers)->
    if !headers
      res.setHeader 'Content-Type', 'application/json'
    else
      for header,value of headers
        res.setHeader header, value
    res
    .status data.status
    .send if data.content then data.content else ""
  requestHandler:->
    # not implemented
    false
module.exports = ExpressAdapter
try 
  API = require '../../rikki-tikki' unless (API = require 'rikki-tikki')?
  API.registerAdapter 'express', ExpressAdapter
catch e
  console.log e
  console.log 'ExpressAdapter not registered.\nreason: rikki-tikki was not found'
module.exports.use = (express)=>
  new ExpressAdapter app:express
