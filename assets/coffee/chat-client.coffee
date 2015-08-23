throw "ApiHeroUI not defined\ntry: npm install --save apihero-ui" unless ApiHeroUI?

class ApiHeroUI.ChatClient extends ApiHeroUI.core.View
  # declares event delegates
  events:
    # handles form submittal
    "submit form":(evt)->
      # prevents the form from actually submitting
      evt.preventDefault()
      # invokes sendMessage to dispacth a message upon the socket
      @sendMessage mssg if (mssg = @$('input[name=memo]').val())?
    # handles textfield input `focus`
    "focus input[name=memo]":"keyboardOnHandler"
    # handles textfield input `blur`
    "blur input[name=memo]":"keyboardOffHandler"
    # handles textfield input `propertychange`
    "propertychange input[name=memo]":"changeHandler"
    # handles textfield input `change`
    "change input[name=memo]":"changeHandler"
    # handles textfield input `keyup`
    "keyup input[name=memo]":"keyUpHandler"
    # handles textfield input `input`
    "input input[name=memo]":"changeHandler"
    # handles textfield input `paste`
    "paste input[name=memo]":"changeHandler"
  # defines handler for iOS Keyboard `show`
  keyboardOnHandler:(evt)->
    # tests if this is a mobile client
    if ApiHeroUI.utils.isMobile() 
      # adds css class to hide nav element
      $('nav').css display:none
      # sets the input field to the bottom of the display
      @$('.input-row').css bottom: 0
      # invokes resize upon our element
      @resize width:window.innerWidth, height:window.innerHeight
  # defines handler for iOS Keyboard `hide`
  keyboardOffHandler:(evt)->
    # tests if this is a mobile client
    if ApiHeroUI.utils.isMobile() 
      # removes css class to unhide nav element
      $('nav').css display:auto
      # restores  input field bottom offset
      @$('.input-row').css bottom:50
      # invokes resize upon our element
      @resize width:window.innerWidth, height:window.innerHeight
  # defines method to send message to socket
  sendMessage:(mssg)->
    # tests if client is Phonegap, closes keyboard if passed
    cordova.plugins.Keyboard.close() if ApiHeroUI.utils.isPhonegap()
    # sets message upon params model if present
    @model.set text:mssg if mssg
    # returns if there is no message to send
    return unless (@model.get 'text')
    # invokes save to send the message
    @model.save()
    # invokes clear to reset the params model
    @model.clear()
    # clears the value from the ui input element
    @$('input[name=memo]').val ''
  # defines keyup event handler
  keyUpHandler:(evt)->
    # tests to insure client is mobile web but not phonegap
    if ApiHeroUI.utils.isMobile() and (ApiHeroUI.utils.isPhonegap() is false)
      # sends message if user clicked "return" key
      @sendMessage mssg if (mssg = @$('input[name=memo]').val())? if evt.which is 13
      # closes the keyboard by bluring the input
      $(evt.target).blur()
  # defines text input change event handler
  changeHandler:(evt)->
    # sets text value upon the model
    @model.set text: (t = $(evt.target).val())
  # defines incoming message handler from Socket listener
  messageHandler:(data)->
    # generates value object ot render template wiht
    o = _.extend {}, data.attributes, data.header.__user
    # applies rendered template upon the message list element
    @$('#messages').append ApiHeroUI.ChatItem.template o
  # defines render callback method
  render:->
    # invokes render upon superclass
    ChatClient.__super__.render.call @
    # tests if client is phonegap
    if ApiHeroUI.utils.isPhonegap()
      # applies margin to top of messages list to make room for status bar
      @$('#messages').addClass 'pg-margin'
  # defines CompositeView init callback
  init:->
    # initializes out params model
    @model = new global[ApiHeroUI.ns].Message
    # obtains instance of socket message listener
    @collection = global[ApiHeroUI.ns].MessageStream.getInstance()
    # handles new message events with messagehandler
    .on 'add', @messageHandler, @
    _oHeight = 0
    # listens for native keyboar hosw events
    window.addEventListener 'native.keyboardshow', =>
      # displaces messages list
      _oHeight = @$('#messages').height()
      @$('#messages').css 'height', _oHeight + 50
    # listens for native keyboar hosw events
    window.addEventListener 'native.keyboardhide', =>
      # removes displacement of messages list
      @$('#messages').css 'height', _oHeight + 2