// Generated by CoffeeScript 1.3.3
var Server, animation, chars, messages, net, util,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

net = require('net');

util = require('util');

animation = require('../assets/animation');

chars = require('../assets/characters');

messages = require('../assets/messages');

Server = (function() {
  var genMsg, nyaned, nyanedString;

  genMsg = function(text, ctx) {
    var str;
    str = '';
    str += chars.clean;
    str += chars.end;
    if (ctx != null) {
      if (text.constructor === Array) {
        text = text.join('\r\n');
      }
      str += util.format.apply(util, arguments);
    } else {
      str += text;
    }
    return str;
  };

  nyaned = function(start) {
    return Math.floor((Date.now() - start) / 1e3);
  };

  nyanedString = function(start) {
    var field, text;
    text = util.format(messages.nyaned, nyaned(start) - 5);
    field = new Array(80 - text.length).join(' ');
    return [chars.text, chars.draw[','], field, text, field, chars.end, chars.textEnd].join('');
  };

  function Server(port, fps) {
    this.port = port;
    this.fps = fps != null ? fps : 12;
    this.client = __bind(this.client, this);

    this.server = net.createServer(this.client);
    this.server.listen(this.port);
  }

  Server.prototype.client = function(con) {
    var frame, intro, start, tick,
      _this = this;
    frame = 0;
    start = Date.now();
    tick = false;
    intro = false;
    con.setEncoding('binary');
    con.on('end', function() {
      clearInterval(tick);
      return clearInterval(intro);
    });
    con.on('data', function(data) {
      switch (data.toString('utf8').trim()) {
        case 'q':
          con.write(chars.clean);
          return con.end();
      }
    });
    con.write(genMsg(messages.intro, 5));
    return intro = setInterval(function() {
      if (nyaned(start) >= 5) {
        clearInterval(intro);
        return tick = setInterval(function() {
          if (frame === 12) {
            frame = 0;
          }
          return con.write(genMsg("" + animation[frame++] + "\r\n" + (nyanedString(start))));
        }, 1e3 / _this.fps);
      } else {
        return con.write(genMsg(messages.intro, 5 - nyaned(start)));
      }
    }, 1e3);
  };

  return Server;

})();

module.exports = Server;
