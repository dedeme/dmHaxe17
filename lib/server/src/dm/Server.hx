/*
 * Copyright 05-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Communication utilities on server side
package dm;

import dm.Io;
import dm.It;
import dm.Json;
import dm.Client;
import dm.Cryp;

class Server {
  public var app(default, null):String;
  public var root(default, null):String;
  var expiration:Float = 90000;
  var userDb:String;
  var sessionDb:String;

  public function new(app:String) {
    this.app = app;
    root = Io.cat([Io.userDir(), "dmcgi", app]);
    userDb = Io.cat([root, "users.db"]);
    sessionDb = Io.cat([root, "sessions.db"]);
  }

  /// 'time' is in hours. Its value is 0.25 by default.
  public function setExpiration(time:Float) {
    expiration = time * 3600000;
  }

  /// Returns the time for session expiration
  public function getExpiration():Float {
    return expiration / 360000;
  }

  function readUser(user:String):Array<UserEntry> {
    var s = Io.read(userDb);
    if (s == "") {
      return [];
    }
    var d = s.split("\n");
    return It.from(d).map(function (e) {
      return UserEntry.restore(e);
    }).find(function (us) {
      return us.user == user;
    });
  }

  function writeUser(userEntry:UserEntry) {
    var d = Io.read(userDb);
    if (d != "") {
      Io.write(userDb, d + "\n" + userEntry.serialize());
    } else {
      Io.write(userDb, userEntry.serialize());
    }
  }

  /// If 'user' already exists, returns 'false'
  public function addUser(user:String, pass:String, level:String):Bool {
    var entry = readUser(user);
    if (entry.length > 0) {
      return false;
    }
    var p = Cryp.key(pass, 120);
    var uentry = new UserEntry(user, p, level);
    writeUser(uentry);
    return true;
  };

  public function delUser(user:String) {
    var s = Io.read(userDb);
    if (s == "") {
      return;
    }
    var d = s.split("\n");
    var nd = It.from(d).filter(function (e) {
      var us = UserEntry.restore(e);
      return us.user != user;
    }).to();
    Io.write(userDb, nd.join("\n"));
  };

  public function changePass(user:String, oldPass:String, newPass:String):Bool {
    var entries = readUser(user);
    if (entries.length == 0) {
      return false;
    }
    var entry = entries[0];
    if (entry.pass != Cryp.key(oldPass, 120)) {
      return false;
    }
    var newUser = new UserEntry(user, Cryp.key(newPass, 120), entry.level);
    delUser(user);
    writeUser(newUser);
    return true;
  }

  public function changeLevel(user:String, level:String):Bool {
    var entries = readUser(user);
    if (entries.length == 0) {
      return false;
    }
    var entry = entries[0];
    var newUser = new UserEntry(user, entry.pass, level);
    this.delUser(user);
    this.writeUser(newUser);
    return true;
  };

  public function readSession(sessionId:String):Array<SessionEntry> {
    var s = Io.read(sessionDb);
    if (s == "") {
      return [];
    }
    var d = s.split("\n");
    return It.from(d).map(function (e) {
      return SessionEntry.restore(e);
    }).find(function (ss) {
      return ss.sessionId == sessionId;
    });
  }

  // str - SessionEntry -
  function writeSession(sessionEntry:SessionEntry) {
    var t = Date.now().getTime();
    var s = Io.read(sessionDb);
    var nd = [];
    if (s != "") {
      var d = Io.read(sessionDb).split("\n");
      nd = It.from(d).filter(function (e) {
        var ss = SessionEntry.restore(e);
        return ss.sessionId != sessionEntry.sessionId && ss.expiration >= t;
      }).to();
    }
    nd.push(sessionEntry.serialize());
    Io.write(sessionDb, nd.join("\n"));
  }


  /**
   * Read client data and send it to 'f'.
   *   data  : JSON value with a ClientRequest (It is raw data send by client)
   *   f     : Function to execute. It receives a JSONizable object (the 'data'
   *           value of the ClientRequest) and returns another JSONizable
   *           object to send in a ClientResponse.
   *   return: JSONized serialized ClientResponse whose field data is the
   *           object returned by 'f'.
   * Example of use:
   *    function x(data) {
   *        var server = dm.Server();
   *        return server.rp(data, function (d) {
   *          return process(d);
   *        });
   *    }
   */
  public function rp(data:String, f:Dynamic->Dynamic):String {
    var dobj = Json.to(data);
    var rq = ClientRequest.restore(dobj.data);

    var rp;
    if (rq.sessionId == null) {
      rp = new ClientResponse("", true, true, "Unkown");
    } else {
      var ss = readSession(rq.sessionId);
      var now = Date.now().getTime();
      if (ss.length == 0) {
        rp = new ClientResponse("", true, true, "Unkown");
      } else if (ss[0].expiration < now) {
        rp = new ClientResponse("", false, true, "Expired");
      } else {
        var s = ss[0];
        var sn = new SessionEntry(
          s.sessionId, s.expiration + s.step, s.step, s.user, s.level
        );
        writeSession(sn);
        rp = new ClientResponse("", false, false, f(rq.data));
      }
    }
    return Json.from(rp.serialize());
  }

  /**
   * Authentificates user.
   *   data  : JSONized serialized ClientRequest.
   *   return: JSONized serialized ClientResponse whose field data is an
   *           AuthResponse (without serialization). If authentification fails
   *           it returns 'new AuthResponse("-1", "")'.
   */
  public function authRp(data:String):String {
    var dobj = Json.to(data);
    var rq = AuthRequest.restore(ClientRequest.restore(dobj.data).data);

    var rp:ClientResponse;
    var pass = Cryp.key(rq.pass, 120);
    var uentry = readUser(rq.user);
    if (uentry.length > 0 && uentry[0].pass == pass) {
      var ex = rq.persistent ? 31536000000 : expiration;
      var sentry = new SessionEntry(
        Cryp.genK(120),
        Date.now().getTime() + ex,
        ex,
        uentry[0].user,
        uentry[0].level
      );
      writeSession(sentry);
      rp = new ClientResponse("", false, false,
        new AuthResponse(uentry[0].level, sentry.sessionId));
    } else {
      rp = new ClientResponse("", false, false, new AuthResponse("-1", ""));
    }

    return Json.from(rp.serialize());
  }

  /// Initializes server and returns a response.  Use:
  ///   server = new Server "app", 0,30
  ///   ... Initialization operations ...
  ///   return server.init!
  public function init() {
    if (!Io.exists(root)) {
      Io.mkdir(root);
      if (!Io.exists(sessionDb)) {
        Io.write(sessionDb, "");
      }
      if (!Io.exists(userDb)) {
        Io.write(userDb, "");
        addUser("admin", Cryp.key("deme", 120), "0");
      }
    }
  };

}

// User data response
private class UserEntry {
  public var user(default, null):String;
  public var pass(default, null):String;
  public var level(default, null):String;

  public function new(user:String, pass:String, level:String) {
    this.user = user;
    this.pass = pass;
    this.level = level;
  }
  public function serialize():String {
    return Cryp.autoCryp(2, Json.from([user, pass, level]));
  }
  public static function restore(serial:String):UserEntry {
    var s = Json.to(Cryp.autoDecryp(serial));
    return new UserEntry(s[0], s[1], s[2]);
  }
}

/// Session data response. Expiration is a Date.getTime().
class SessionEntry {
  public var sessionId(default, null):String;
  public var expiration(default, null):Float;
  public var step(default, null):Float;
  public var user(default, null):String;
  public var level(default, null):String;

  public function new(
    sessionId:String, expiration:Float, step:Float, user:String, level:String
  ) {
    this.sessionId = sessionId;
    this.expiration = expiration;
    this.step = step;
    this.user = user;
    this.level = level;
  }
  public function serialize() {
    return Cryp.autoCryp(2, Json.from(
      [sessionId, expiration, step, user, level]
    ));
  }
  public static function restore(serial:String):SessionEntry {
    var s = Json.to(Cryp.autoDecryp(serial));
    return new SessionEntry(s[0], cast(s[1]), cast(s[2]), s[3], s[4]);
  }
}
