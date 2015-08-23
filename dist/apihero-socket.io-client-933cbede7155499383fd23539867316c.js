var ApiHero;

ApiHero = {
  WebSock: {}
};var ApiHero, Backbone,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

if (typeof window === "undefined" || window === null) {
  Backbone = require('backbone');
  ApiHero = {
    WebSock: {}
  };
}

ApiHero.WebSock.StreamModel = (function(superClass) {
  extend(StreamModel, superClass);

  function StreamModel() {
    return StreamModel.__super__.constructor.apply(this, arguments);
  }

  StreamModel.prototype.header = {};

  StreamModel.prototype.initialize = function(attributes, options) {
    var getFunctionName;
    getFunctionName = function(fun) {
      var n;
      if ((n = fun.toString().match(/function+\s{1,}([a-zA-Z]{1,}[_0-9a-zA-Z]?)/)) != null) {
        return n[1];
      } else {
        return null;
      }
    };
    this.__type = ((function(_this) {
      return function(fun) {
        var name;
        return fun.constructor.name || ((name = getFunctionName(fun.constructor)) != null ? name : '__UNDEFINED_CLASSNAME__');
      };
    })(this))(this);
    return StreamModel.__super__.initialize.call(this, attributes, options);
  };

  StreamModel.prototype.sync = function(mtd, mdl, opt) {
    var base, m;
    if (opt == null) {
      opt = {};
    }
    m = {};
    if (opt.header != null) {
      _.extend(this.header, opt.header);
    }
    if (mtd === 'create') {
      if ((base = this.header).type == null) {
        base.type = this.__type;
      }
      m.header = _.extend(this.header, {
        sntTime: Date.now()
      });
      m.body = mdl.attributes;
      return StreamModel.__connection__.socket.emit('ws:datagram', m);
    }
  };

  StreamModel.prototype.getSenderId = function() {
    return this.header.sender_id || null;
  };

  StreamModel.prototype.getSentTime = function() {
    return this.header.sntTime || null;
  };

  StreamModel.prototype.getServedTime = function() {
    return this.header.srvTime || null;
  };

  StreamModel.prototype.getRecievedTime = function() {
    return this.header.rcvTime || null;
  };

  StreamModel.prototype.getSize = function() {
    return this.header.size || null;
  };

  StreamModel.prototype.setRoomId = function(id) {
    return this.header.room_id = id;
  };

  StreamModel.prototype.getRoomId = function() {
    return this.header.room_id;
  };

  StreamModel.prototype.parse = function(data) {
    this.header = Object.freeze(data.header);
    return StreamModel.__super__.parse.call(data.body);
  };

  return StreamModel;

})(Backbone.Model);

if (typeof window === "undefined" || window === null) {
  module.exports = ApiHero.WebSock.StreamModel;
}
;
var ApiHero, Backbone,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

if (typeof window === "undefined" || window === null) {
  Backbone = require('backbone');
  ApiHero = {
    WebSock: {}
  };
  ApiHero.WebSock.StreamModel = require('./stream-model');
}

ApiHero.WebSock.StreamCollection = (function(superClass) {
  extend(StreamCollection, superClass);

  function StreamCollection() {
    return StreamCollection.__super__.constructor.apply(this, arguments);
  }

  StreamCollection.prototype.model = ApiHero.WebSock.StreamModel;

  StreamCollection.prototype.fetch = function() {
    console.log("StreamModel::fetch is not allowed");
    return false;
  };

  StreamCollection.prototype.sync = function() {
    console.log("StreamModel::sync is not allowed");
    return false;
  };

  StreamCollection.prototype._prepareModel = function(attrs, options) {
    var model;
    if (attrs instanceof Backbone.Model) {
      if (!attrs.collection) {
        attrs.collection = this;
      }
      return attrs;
    }
    options = options ? _.clone(options) : {};
    options.collection = this;
    model = new this.model(attrs.body, options);
    model.header = Object.freeze(attrs.header);
    if (!model.validationError) {
      return model;
    }
    this.trigger('invalid', this, model.validationError, options);
    return false;
  };

  StreamCollection.prototype.send = function(data) {
    return this.create(data);
  };

  StreamCollection.prototype.initialize = function() {
    var _client;
    if (arguments[0] instanceof ApiHero.WebSock.Client) {
      return _client = arguments[0];
    }
  };

  return StreamCollection;

})(Backbone.Collection);

if (typeof window === "undefined" || window === null) {
  module.exports = ApiHero.WebSock.StreamCollection;
}
;
var ApiHero, Backbone,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

if (typeof window === "undefined" || window === null) {
  Backbone = require('backbone');
  ApiHero = {
    WebSock: {}
  };
}

ApiHero.WebSock.ValidationModel = (function(superClass) {
  extend(ValidationModel, superClass);

  function ValidationModel() {
    return ValidationModel.__super__.constructor.apply(this, arguments);
  }

  ValidationModel.prototype.defaults = {
    header: {
      sender_id: String,
      type: String,
      sntTime: Date,
      srvTime: Date,
      rcvTime: Date,
      size: Number
    },
    body: null
  };

  ValidationModel.prototype.validate = function(o) {
    var i, key, len, ref;
    if (o == null) {
      o = this.attributes;
    }
    if (o.header == null) {
      return "required part 'header' was not defined";
    }
    ref = this.defaults.header;
    for (i = 0, len = ref.length; i < len; i++) {
      key = ref[i];
      if (o.header[key] == null) {
        return "required header " + key + " was not defined";
      }
    }
    if (typeof o.header.sender_id !== 'string') {
      return "wrong value for sender_id header";
    }
    if (typeof o.header.type !== 'string') {
      return "wrong value for type header";
    }
    if ((new Date(o.header.sntTime)).getTime() !== o.header.sntTime) {
      return "wrong value for sntTime header";
    }
    if ((new Date(o.header.srvTime)).getTime() !== o.header.srvTime) {
      return "wrong value for srvTime header";
    }
    if ((new Date(o.header.rcvTime)).getTime() !== o.header.rcvTime) {
      return "wrong value for rcvTime header";
    }
    if (!o.body) {
      return "required part 'body' was not defined";
    }
    if (!JSON.stringify(o.body === o.size)) {
      return "content size was invalid";
    }
  };

  return ValidationModel;

})(Backbone.Model);

ApiHero.WebSock.SocketIOConnection = (function(superClass) {
  extend(SocketIOConnection, superClass);

  SocketIOConnection.prototype.defaults = {
    host: 'localhost',
    port: 80,
    multiplex: true,
    reconnection: true,
    reconnectionDelay: 1000,
    reconnectionDelayMax: 5000,
    timeout: 20000
  };

  function SocketIOConnection(__options) {
    var _socket, opts;
    this.__options = __options;
    opts = _.extend({}, this.defaults, _.pick(this.__options, _.keys(this.defaults)));
    _socket = io("" + this.__addr, opts).on('ws:datagram', (function(_this) {
      return function(data) {
        var dM, stream;
        data.header.rcvTime = Date.now();
        (dM = new _this.validator).set(data);
        if (dM.isValid() && ((stream = _this.__streamHandlers[dM.attributes.header.type]) != null)) {
          return stream.add(dM.attributes);
        }
      };
    })(this)).on('connect', (function(_this) {
      return function() {
        WebSock.StreamModel.__connection__ = _this;
        return _this.trigger('connect', _this);
      };
    })(this)).on('disconnect', (function(_this) {
      return function() {
        return _this.trigger('disconnect');
      };
    })(this)).on('reconnect', (function(_this) {
      return function() {
        return _this.trigger('reconnect');
      };
    })(this)).on('reconnecting', (function(_this) {
      return function() {
        return _this.trigger('reconnecting', _this);
      };
    })(this)).on('reconnect_attempt', (function(_this) {
      return function() {
        return _this.trigger('reconnect_attempt', _this);
      };
    })(this)).on('reconnect_error', (function(_this) {
      return function() {
        return _this.trigger('reconnect_error', _this);
      };
    })(this)).on('reconnect_failed', (function(_this) {
      return function() {
        return _this.trigger('reconnect_failed', _this);
      };
    })(this)).on('error', (function(_this) {
      return function() {
        return _this.trigger('error', _this);
      };
    })(this));
    this.getSocket = (function(_this) {
      return function() {
        return _socket;
      };
    })(this);
  }

  return SocketIOConnection;

})(Backbone.Events);

ApiHero.WebSock.SocketIOConnection.prototype.validator = ApiHero.WebSock.ValidationModel;

if (typeof window === "undefined" || window === null) {
  module.exports = ApiHero.WebSock.SocketIOConnection;
}
;
var ApiHero, Backbone, SockData;

if (typeof window === "undefined" || window === null) {
  Backbone = require('backbone');
  SockData = require('./models/sockdata');
  ApiHero = {
    WebSock: {}
  };
  module.exports = Client;
}

ApiHero.WebSock.Client = (function() {
  Client.prototype.__streamHandlers = {};

  function Client(__addr, __options) {
    this.__addr = __addr;
    this.__options = __options != null ? __options : {};
    _.extend(this, Backbone.Events);
    this.model = ApiHero.WebSock.SockData;
    if (!((this.__options.auto_connect != null) && this.__options.auto_connect === false)) {
      this.connect();
    }
  }

  Client.prototype.connect = function() {
    this.__conn = new connection(this.__options);
    return this;
  };

  Client.prototype.addStream = function(name, clazz) {
    var s;
    if ((s = this.__streamHandlers[name]) != null) {
      return s;
    }
    this.__streamHandlers[name] = clazz;
    return this;
  };

  Client.prototype.removeStream = function(name) {
    if (this.__streamHandlers[name] == null) {
      return null;
    }
    delete this.__streamHandlers[name];
    return this;
  };

  Client.prototype.getClientId = function() {
    var ref, ref1;
    if (((ref = this.socket) != null ? (ref1 = ref.io) != null ? ref1.engine : void 0 : void 0) == null) {
      return null;
    }
    return this.socket.io.engine.id;
  };

  return Client;

})();if (typeof RikkiTikki === "undefined" || RikkiTikki === null) {
  throw console.log("ApiHero not found -- insure it is isntalled nd added to your JS stack");
}

RikkiTikki.extend(ApiHero);
/*
(=) require _init
(=) require ./models/stream-model
(=) require ./models/stream-collection
(=) require connection
(=) require index
(=) require _apply
 */
;
