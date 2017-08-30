/*
 * Copyright 04-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Cgi management.<p>
/// For working with cgi you must make next initialization:
///   App.cgi(<i>path</i>);
///   Cgi.init();
/// For example:
///   App.cgi("/home/me/wwwcgi/App")
///   Cgi.init();
///   trace(App.home); // -> /home/me/wwwcgi/App
///   trace(Cgi.app);  // -> App
/// Cgi receives request codified with B64, but send request in plain text.<p>
/// There are a bunch of variables synchronized with dm.Client (class of
/// library 'basic'). PAGE_ID, SESSION_ID, EXPIRATION, USER, PASS, OLD_PASS,
/// ERROR, OK and CHPASS_OK should not be used as field name.<p>
/// PAGE is used to identify the origin page of a request. It can be set as
/// long as not receives values either PAGE_CONNECTION, PAGE_AUTHENTICATION
/// or PAGE_CHPASS.
package dm;

import dm.Io;
import dm.Cryp;
import dm.Json;
import dm.App;

class Cgi {
  static inline var K = "var expiration = persistent ? 2592000 : 900;";

  static inline var U_DB = "users.db";
  static inline var U_PASS = 0;
  static inline var U_LEVEL = 1;

  static inline var SS_DB = "sessions.db";
  static inline var SS_USER = 0;
  static inline var SS_LEVEL = 1;
  static inline var SS_TIME = 2;
  static inline var SS_INC_TIME = 3;
  static inline var SS_PAGE_ID = 4;

  /// Request field to identify page source
  public static inline var PAGE = "page";
  /// (Reserved) Request field to send the page identifier
  public static inline var PAGE_ID = "pageId";
  /// (Reserved) Request field to send the session identifier and to store it
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

  /// Application name (it is the last subdirectory of home path)
  public static var app(default, null):String;

  inline static function b64write(file:String, tx:String) {
    Io.write(file, Cryp.cryp(K, tx));
  }

  inline static function b64read(file:String):String {
    return Cryp.decryp(K, Io.read(file));
  }

  /// Initializes Cgi. It creates userdb and sessionsdb the first time that
  /// it is called.
  public static function init() {
    var path = App.home;
    app = Io.name(path);

    var fusers = Io.cat([path, U_DB]);
    var fsessions = Io.cat([path, SS_DB]);

    if (!Io.exists(fusers)) {
      var userdb = new Map<String, Array<String>>();
      userdb.set("admin", [
        "CaZkw7OHNkp618+7zWhasQcHYc/BBWNV+zeyqVPQjwU982S4/d1PwvSWtVPFE4upqI" +
        "kuvFYlQ9IZnCdI80vN8iid54Xn/3Cwki/SDVYNWFvKXsTIs8Z0Z/v+",
        "0"
      ]);
      b64write(fusers, Json.from(userdb));
    }
    if (!Io.exists(fsessions)) {
      var sessiondb = new Map<String, String>();
      b64write(fsessions, Json.from(sessiondb));
    }
  }

  /// Sets pageId and returns trueo if sessionId is correct.
  public static function connect(sessionId:String, pageId:String):Bool {
    var fsessions = Io.cat([App.home, SS_DB]);
    var sessionsOld = Json.toMap(b64read(fsessions));

    var now = Date.now().getTime();
    var sessions = new Map<String, Dynamic>();
    It.fromIterator(sessionsOld.keys()).each(function (k) {
      var v = sessionsOld.get(k);
      if (v[SS_TIME] > now) {
        sessions.set(k, v);
      }
    });

    var ssData = sessions.get(sessionId);
    if (ssData == null) {
      return false;
    }
    ssData[SS_PAGE_ID] = pageId;
    ssData[SS_TIME] = ssData[SS_INC_TIME] + now;

    b64write(fsessions, Json.from(sessions));
    return true;
  }

  /// 'incTime' is in seconds
  public static function authentication(
    user:String, pass:String, incTime:Float
  ):String {
    incTime = incTime * 1000.0;
    var users = Json.toMap(b64read(Io.cat([App.home, U_DB])));
    var uData = users.get(user);

    if (uData == null) {
      return "";
    }
    if (uData[U_PASS] != pass) {
      return "";
    }

    var fsessions = Io.cat([App.home, SS_DB]);
    var sessions = Json.toMap(b64read(fsessions));

    var sessionId = Std.string(Rnd.i(9999999));
    var time = Date.now().getTime() + incTime;

    var ssData = new Array<Dynamic>();
    ssData[SS_USER] = user;
    ssData[SS_LEVEL] = uData[U_LEVEL];
    ssData[SS_TIME] = time;
    ssData[SS_INC_TIME] = incTime;
    ssData[SS_PAGE_ID] = "";

    sessions.set(sessionId, ssData);
    b64write(fsessions, Json.from(sessions));

    return sessionId;
  }

  /// Changes password
  public static function changePass(
    user:String, oldPass:String, newPass:String
  ):Bool {
    var fusers = Io.cat([App.home, U_DB]);
    var users = Json.toMap(b64read(fusers));
    var uData = users.get(user);

    if (uData == null) {
      return false;
    }
    if (uData[U_PASS] != oldPass) {
      return false;
    }

    uData[U_PASS] = newPass;

    b64write(fusers, Json.from(users));
    return true;
  }

  /// Returns true if sessionId and pageId are correct, increassing timeout.
  public static function control(sessionId:String, pageId:String):Bool {
    var now = Date.now().getTime();

    var fsessions = Io.cat([App.home, SS_DB]);
    var sessions = Json.toMap(b64read(fsessions));
    var ssData:Array<Dynamic> = sessions.get(sessionId);

    if (ssData == null) {
      return false;
    }

    if (ssData[SS_PAGE_ID] == pageId && ssData[SS_TIME] > now) {
      ssData[SS_TIME] = ssData[SS_INC_TIME] + now;
      b64write(fsessions, Json.from(sessions));
      return true;
    }

    sessions.remove(sessionId);
    b64write(fsessions, Json.from(sessions));
    return false;
  }

  /// Sends an ok response. An ERROR field is added with value ""
  public static function ok(rp:Map<String, Dynamic>) {
    rp.set(ERROR, "");
    Sys.print(Json.from(rp));
  }

  /// Sends an error response.
  ///   rq : Request sent by client
  ///   err: Error message
  public static function error(rq:Map<String, Dynamic>, err:String) {
    var rp = new Map<String, Dynamic>();
    rp.set(ERROR, '$err\nRequest:\n${Json.from(rq)}');
    Sys.print(Json.from(rp));
  }
}

