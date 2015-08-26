class ApiHeroUI.WebSock.ChatView extends ApiHeroUI.core.View
  events:
    "submit form":(evt)->
      evt.preventDefault()
      @sendMessage mssg if (mssg = @$('input[name=memo]').val())?
    "focus input[name=memo]":"keyboardOnHandler"
    "blur input[name=memo]":"keyboardOffHandler"
    "propertychange input[name=memo]":"changeHandler"
    "change input[name=memo]":"changeHandler"
    "keyup input[name=memo]":"keyUpHandler"
    "input input[name=memo]":"changeHandler"
    "paste input[name=memo]":"changeHandler"
    "click a.btn.submit":(evt)->
      evt.preventDefault()
      @sendMessage()
    "click a.details-btn":->
      $('.details-overlay').removeClass 'hidden'
  keyboardOnHandler:(evt)->
    if global.Util.isMobile() 
      $('nav').addClass 'hidden'
      @$('.input-row').css bottom: 0 # if window.orientation is 0 then 0 else 25
      @resize width:window.innerWidth, height:window.innerHeight
  keyboardOffHandler:(evt)->
    if global.Util.isMobile() 
      $('nav').removeClass 'hidden'
      @$('.input-row').css bottom:50
      # @$('#messages').height @$('#messages').height() - 100
      @resize width:window.innerWidth, height:window.innerHeight  
  sendMessage:(mssg)->
    cordova.plugins.Keyboard.close() if global.Util.isPhonegap()
    @model.set text:mssg if mssg
    return unless (@model.get 'text')
    @model.save()
    @model.clear()
    @$('input[name=memo]').val ''
    @$('a.btn.submit').addClass 'disabled'
  keyUpHandler:(evt)->
    if global.Util.isMobile() and (global.Util.isPhonegap() is false)
      @sendMessage mssg if (mssg = @$('input[name=memo]').val())? if evt.which is 13
      $(evt.target).blur()
  changeHandler:(evt)->
    console.log 'change'
    @model.set text: (t = $(evt.target).val())
    @$('a.btn.submit')["#{if t.length then 'remove' else 'add'}Class"] 'disabled'
  messageHandler:(data)->
    console.log 'messageHandler:'
    console.log data
    o = _.extend {}, data.attributes, data.header.__user
    @$('#messages').append templates['_elements/chat-item'] o
  render:->
    ChatView.__super__.render.call @
    if global.Util.isPhonegap()
      @$('#messages').addClass 'pg-margin'
  resize:(d)->
    return
    return unless d?
    mrgn = (@$('#messages').css 'margin-top') || 0
    mrgn = parseInt mrgn.replace 'px', '' if typeof mrgn is 'string'
    offset = if $('nav').css( 'display') is 'none' then 85 else 100
    offset = offset - if global.Util.isPhonegap() then 23 else 0 #(if global.Util.isMobile() then 50 else 0))
    @$('#messages').height d.height - (offset + mrgn)
  init:->
    _oHeight = 0
    window.addEventListener 'native.keyboardshow', =>
      _oHeight = @$('#messages').height()
      @$('#messages').css 'height', _oHeight + 50
    window.addEventListener 'native.keyboardhide', =>
      @$('#messages').css 'height', _oHeight + 2