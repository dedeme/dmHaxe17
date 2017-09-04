/*
 * Copyright 05-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Client for cgi-executable applications.<p>
/// <h3>Structure</h3>
/// Client works in combination with the file 'cdmcgi.sh'.<p>
/// To create an application client-server it is necessary:
/// <li>Link www in server-www.</li>
/// <li>Indicate the absolute path of executable program.</li><p>
/// CLient send its requests to <tt>http://" + js.Browser.location.host +
/// "/cgi-bin/cdmcgi.sh</tt>, so <tt>/cgi-bin/</tt> must be habilited as cgi
/// directory in Apache configuration.<p>
/// <h2>Process</h2>
/// <ul><li>Call 'connect()'. This function use a new pageId and the last
/// stored sessionId.
/// <ul><li>If sessionId is not Ok an authentication page is launched. This
/// will call 'authentication()' until the result is Ok.</li>
/// <li>If sessionId is Ok, program can go on calling 'request()'</li></ul>
/// </li></ul>
/// <h2>Variables</h2>
/// There are a bunch of variables synchronized with dm.Cgi (class of
/// library 'cbasic'). PAGE_ID, SESSION_ID, EXPIRATION, USER, PASS, OLD_PASS,
/// ERROR, OK and CHPASS_OK should not be used as field name.<p>
/// PAGE is used to identify the origin page of a request. It can be set as
/// long as not receives values either PAGE_CONNECTION, PAGE_AUTHENTICATION
/// or PAGE_CHPASS.
/// <h2>Notes</h2>
/// <li>A special request is 'chpass()', which change user password.</li>
/// <li>Session is closed with 'close()'
package dm;

using StringTools;
import dm.B64;
import dm.Json;
import dm.Store;

class Client {
  /// Request field to identify page source
  public static inline var PAGE = "page";
  /// (Reserved) Request field to send the page identifier
  public static inline var PAGE_ID = "pageId";
  /// (Reserved) Request - Response field to:
  ///   Request : send the session identifier
  ///   Response: Receive the result of an authentication
  public static inline var SESSION_ID = "sessionId";
  /// (Reserved) Request field to indicate expiration time
  public static inline var EXPIRATION = "expirationTime";
  /// (Reserved) Request field to indicate user name
  public static inline var USER = "user";
  /// (Reserved) Request field to indicate user password
  public static inline var PASS = "pass";
  /// (Reserved) Request field to indicate old user password
  public static inline var OLD_PASS = "oldPass";
  /// (Reserved) Response field for errors
  public static inline var ERROR = "error";
  /// (Reserved) Response field for session-page control
  public static inline var OK = "sessionOk";
  /// (Reserved) Response field for change-password control
  public static inline var CHPASS_OK = "chpassOk";
  /// (Reserved) Page value to set connection.
  public static inline var PAGE_CONNECTION = "_ClientConnection";
  /// (Reserved) Page value for authentication.
  public static inline var PAGE_AUTHENTICATION = "_ClientAuthentication";
  /// (Reserved) Page value for change-password.
  public static inline var PAGE_CHPASS = "_ClientChpass";

  var lockIx:Int;
  var unlockIx:Int;

  /// Application name.
  public var appName(default, null):String;
  /// User name.
  public var user(default, null):String;
  var executable:String;
  var pageId:String;
  var fexpired:Void->Void;

  static function userIdKey(appName:String) {
    return "Client_" + appName + "_userId";
  }

  static function sessionIdKey(appName:String) {
    return "Client_" + appName + "_sessionId";
  }

  static function send(url:String, rq:Dynamic, f:Map<String, Dynamic> -> Void) {
    var request = js.Browser.createXMLHttpRequest();
    request.onreadystatechange = function (e) {
      if (request.readyState == 4) {
        try {
          var rp = Json.toMap(B64.decode(request.responseText.trim()));
          try {
            var error = rp.get(ERROR);
            if (error == "") {
              f(rp);
            } else {
              throw (error);
            }
          } catch(e:Dynamic) {
            trace(e);
          }
        } catch (e:Dynamic) {
          trace(request.responseText);
          trace(B64.decode(request.responseText));
        }
      }
    };
    request.open("POST", url, true);
    request.setRequestHeader(
      "Content-Type"
    , "application/x-www-form-urlencoded;charset=UTF-8"
    );
    request.send(rq);
  }

  /// Creates a new CClient
  ///   executable: Path to c executable. (e.g.: /home/me/capp/bin/app)
  ///   user      : User name (e.g.: "Deme")
  ///   appName   : Program name. (e.g.: "App")
  ///   fexpired  : Callback to call if session is expired.
  function new(
    executable:String,
    appName:String,
    user:String,
    fexpired:Void -> Void
  ) {
    this.executable = executable;
    this.user = user;
    this.appName = appName;
    this.fexpired = fexpired;
    pageId = Std.string(dm.Rnd.i(9999999));
    this.lockIx = 0;
    this.unlockIx = 1;
  }

  /// Try to start a connection
  static public function connect(
    executable:String,
    appName:String,
    fexpired:Void -> Void,
    callback:Null<Client> -> Void
  ) {
    var user = Store.get(Client.userIdKey(appName));
    var sessionId = Store.get(Client.sessionIdKey(appName));

    if (user == null || sessionId == null) {
      callback(null);
    } else {
      var client = new Client(executable, appName, user, fexpired);
      var data = new Map();
      data.set(PAGE, PAGE_CONNECTION);
      data.set(PAGE_ID, client.pageId);
      data.set(SESSION_ID, sessionId);
      send(
        "http://" + js.Browser.location.host + "/cgi-bin/cdmcgi.sh",
        executable + " " + B64.encode(Json.fromMap(data)),
        function (rp) {
          if (rp.get(OK)) {
            callback(client);
          } else {
            callback(null);
          }
        }
      );
    }
  }

  /// Send an authentication request.
  ///   user: User name (Default "admin")
  ///   pass: Password (Default "deme"). Previously encrypted.
  ///   expirationTime: Second to page expiration
  ///   callback: Calback whick receive true if authentication successes
  static public function authentication(
    executable:String,
    appName:String,
    user:String,
    pass:String,
    expirationTime: Float,
    callback: Bool -> Void
  ) {
    var client = new Client(executable, appName, user, null);
    var data = new Map<String, Dynamic>();
    data.set(PAGE, PAGE_AUTHENTICATION);
    data.set(USER, user);
    data.set(PASS, pass);
    data.set(EXPIRATION, expirationTime);
    send(
      "http://" + js.Browser.location.host + "/cgi-bin/cdmcgi.sh",
      executable + " " + B64.encode(Json.fromMap(data)),
      function (data) {
        var sessionId:String = data.get(SESSION_ID);
        Store.put(Client.userIdKey(appName), user);
        Store.put(Client.sessionIdKey(appName), sessionId);
        callback(sessionId != "");
      }
    );
  }

  /// Changes password
  public function chpass(
    oldPass:String,
    newPass:String,
    callback:Bool->Void
  ) {
    var rq = new Map();
    rq.set(PAGE, PAGE_CHPASS);
    rq.set(USER, user);
    rq.set(PASS, newPass);
    rq.set(OLD_PASS, oldPass);

    request(rq, function (rp) {
      var ok = rp.get(CHPASS_OK);
      if (ok == null) {
        throw ("Field value '" + CHPASS_OK + "' is missing in server response");
      } else {
        callback(ok);
      }
    });
  }

  /// Sends a request to server.
  ///   data    : Jsonizable values. Keys "sessionId" and "pageId" are reserved.
  ///   callback: Function which receives Jsonizable values from server. It
  ///             has to have an "Ok" field, which indicate if session is
  ///             valid, and a "error" field for other failures, both are
  ///             processed by CClient.
  public function request(
    data:Map<String, Dynamic>,
    callback:Map<String, Dynamic>->Void
  ) {
    function callback2 (rp:Map<String, Dynamic>) {
      callback(rp);
      ++unlockIx;
    }
    function rq () {
      var sessionId = Store.get(Client.sessionIdKey(appName));
      if (sessionId == null) {
        data.set(SESSION_ID, "");
      } else {
        data.set(SESSION_ID, sessionId);
      }
      data.set(PAGE_ID, pageId);

      send(
        "http://" + js.Browser.location.host + "/cgi-bin/cdmcgi.sh",
        executable + " " + B64.encode(Json.fromMap(data)),
        function (rp) {
          var ok = rp.get(OK);
          if (ok == null) {
            throw ("Field value '" + OK + "' is missing in server response");
          } else if (ok) {
            callback2(rp);
          } else {
            fexpired();
          }
        }
      );
    }

    var timer = new haxe.Timer(100);
    ++lockIx;
    if (lockIx > unlockIx) {
      timer.run = function() {
        if (lockIx <= unlockIx) {
          timer.stop();
          rq();
        }
      }
    } else {
      rq();
    }
  }

  /// Close connection
  public function close () {
    Store.del(Client.sessionIdKey(appName));
  }

}

