io        = require 'socket.io-client'
socketURL = '3000'
options = 
  transports: ['websocket']
  'force new connection': true
  
describe 'socket.io test suite', =>
  it 'should connect', (done)=>
    # console.log options
    client1 = io.connect "http://0.0.0.0:#{app.get 'port'}", options
    # console.log client1
    client1.on 'connect', =>
      done.apply @, arguments

  
