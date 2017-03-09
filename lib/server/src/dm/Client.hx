/*
 * Copyright 05-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Communication utilities on client side
package dm;

import dm.Ajax;
import dm.Store;

class Client {
  var app:String;
  var authFail:Void->Void;
  var expired:Void->Void;
  var userStore:String;
  var sessionIdStore:String;
  var levelStore:String;
  var locked = false;
  var pageId = "";
  var pageIdAction:Void->Void;
  var pageIdStore:String;

  /// Create a new Client.
  ///   app     : Application name
  ///   authFail: Action to do if user is not granted
  ///   expired : Action to do if session is expired
  public function new(app:String, authFail:Void->Void, expired:Void->Void) {
    this.app = app;
    this.authFail = authFail;
    this.expired = expired;
    userStore = '_${app}__user';
    sessionIdStore = '_${app}__sessionId';
    levelStore = '_${app}__level';
    pageIdStore = '_${app}__pageId';
  }

  /// Sets a new page identifier
  ///   action : Action to do if 'controlPageId' fails
  public function setPageId(action:Void->Void) {
    pageId = Cryp.genK(250);
    pageIdAction = action;
    Store.put(pageIdStore, pageId);
  }

  /// Sends to action indicated in 'setPageId' if pageId is not correct.<p>
  /// If control succeeds, return 'true'
  public function controlPageId():Bool {
    var store = Store.get(pageIdStore);
    if (store == null) throw "Store.get(pageIdStore) is null";
    if (store != pageId) {
      pageIdAction();
      return false;
    }
    return true;
  }

  /// Returns user name or null if there is not an user granted.
  public function getUser():Null<String> {
    return Store.get(userStore);
  }

  /// Sets user name
  public function setUser(userName:String) {
    Store.put(userStore, userName);
  }

  /// Returns sessionId or null if there is not an session initiate.
  public function getSessionId():Null<String> {
    return Store.get(sessionIdStore);
  }

  /// Sets sessionId
  public function setSessionId(sessionIdValue:String) {
    Store.put(sessionIdStore, sessionIdValue);
  }

  /// Returns user level or null if there is not an user granted.
  public function getLevel():Null<String> {
    return Store.get(levelStore);
  }

  /// Sets user level
  public function setLevel(levelValue:String) {
    Store.put(levelStore, levelValue);
  }

  /// Closes session and cleans the local storage
  public function close() {
    Store.del(userStore);
    Store.del(sessionIdStore);
    Store.del(levelStore);
    Store.del(pageIdStore);
  }

  /**
   * Sends a locking request to server.<p>
   *
   *   script : Script path to read (e.g. "main/index.js")
   *   func   : Function to execute in server (e.g. "session").
   *   data   : Object serializable. Data that will be
   *            pass to 'func' through a ClientRequest serialized.
   *   action : Normal callback function. Data is received through a
   *            ClientResponse serialized. Client manage ClientResponse fields
   *            error and expired and send field data to 'action'.
   */
  public function send(
    script:String, func:String, data:Dynamic, action:Dynamic->Void
  ) {
    if (locked) {
      trace("Request cancelled because there is other request in course.");
      return;
    }
    locked = true;
    var rq = new ClientRequest(getSessionId(), data);

    function f(arr:Array<Dynamic>) {
      locked = false;
      var d = ClientResponse.restore(arr);
      if (d.error != null && d.error != "") trace(d.error);
      else if (d.unknown) authFail();
      else if (d.expired) expired();
      else action(d.data);
    }

    var pars = {
      "app_name" : app,
      "script"   : script,
      "func"     : func,
      "data"     : rq.serialize()
    };
    Ajax.send(
      "http://" + js.Browser.location.host + "/cgi-bin/jdmcgi.sh", pars, f
    );
  }

  /**
   * Sends an authentication request
   *   script : Script path to read (e.g. "main/index.js")
   *   func   : Function to execute in server (e.g. "session").
   *   data   : Request
   *   action : callback
   */
  //# str - str - str - func() -
  public function authSend(
    script:String, func:String, authRq:AuthRequest, action:Void->Void
  ) {
    var rq = new ClientRequest("", authRq.serialize());
    // Arr<*> -
    function f(arr:Array<Dynamic>) {
      var d = ClientResponse.restore(arr);
      if (d.error != null && d.error != "" ) {
        trace(d.error);
      } else {
        setUser(authRq.user);
        var rp:AuthResponse = d.data;
        setLevel(rp.level);
        setSessionId(rp.sessionId);
        action();
      }
    };
    var pars = {
      "app_name" : app,
      "script"   : script,
      "func"     : func,
      "data"     : rq.serialize()
    };
    Ajax.send(
      "http://" + js.Browser.location.host + "/cgi-bin/jdmcgi.sh",
      pars, f
    );
  }

}

/// Internal class used by dm.Client and dm.Server
class ClientRequest {
  public var sessionId(default, null):Null<String>;
  public var data(default, null):Dynamic;

  /// data must be a serializable object
  public function new(sessionId:Null<String>, data:Dynamic) {
    this.sessionId = sessionId;
    this.data = data;
  }

  public function serialize():Array<Dynamic> {
    return [sessionId, data];
  }

  public static function restore(s:Array<Dynamic>) {
    return new ClientRequest(s[0], s[1]);
  }
}

/// Internal class used by dm.Client and dm.Server
class ClientResponse {
  public var error(default, null):String;
  public var unknown(default, null):Bool;
  public var expired(default, null):Bool;
  public var data(default, null):Dynamic;

  /// data must be a serializable object
  public function new(
    error:String, unknown:Bool, expired:Bool, data:Dynamic
  ){
    this.error = error;
    this.unknown = unknown;
    this.expired = expired;
    this.data = data;
  }

  public function serialize():Array<Dynamic> {
    return [error, unknown, expired,data];
  }

  public static function restore(s:Array<Dynamic>) {
    return new ClientResponse(s[0], s[1], s[2], s[3]);
  }
}

/// Internal class used by dm.Client and dm.Server
class AuthRequest {
  public var user(default, null):String;
  public var pass(default, null):String;
  public var persistent(default, null):Bool;

  /// 'pass' is encripted with 'cryp.key(password, 120)'
  public function new(user:String, pass:String, persistent:Bool) {
    this.user = user;
    this.pass = pass;
    this.persistent = persistent;
  }

  public function serialize():Array<Dynamic> {
    return [user, pass, persistent];
  }

  public static function restore(s:Array<Dynamic>) {
    return new AuthRequest(s[0], s[1], s[2]);
  }
}

/// Internal class used by dm.Client and dm.Server
class AuthResponse {
  public var level(default, null):String;
  public var sessionId(default, null):String;

  /// 'pass' is encripted with 'cryp.key(password, 120)'
  public function new(level:String, sessionId:String) {
    this.level = level;
    this.sessionId = sessionId;
  }

  public function serialize():Array<Dynamic> {
    return [level, sessionId];
  }

  public static function restore(s:Array<Dynamic>) {
    return new AuthResponse(s[0], s[1]);
  }
}
