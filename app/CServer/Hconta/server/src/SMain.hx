/*
 * Copyright 05-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.B41;
import dm.Json;
import dm.Cgi;
import dm.App;
import Db;

/// Server entry point
class SMain {
  static inline var DATA_PATH = "/deme/wwwcgi/dmcgi/Hconta";

  static function reply (
    rq:Map<String, Dynamic>,
    action:Map<String, Dynamic> -> Map<String, Dynamic>
  ) {
    var rp = new Map<String, Dynamic>();
    var sessionId = rq.get(Cgi.SESSION_ID);
    var pageId = rq.get(Cgi.PAGE_ID);
    if (Cgi.control(sessionId, pageId)) {
      rp = action(rq);
      rp.set(Cgi.OK, true);
    } else {
      rp.set(Cgi.OK, false);
    }
    Cgi.ok(rp);
  }

  /// Entry point
  public static function main() {
    App.cgi(DATA_PATH);
    Cgi.init();

    var rq = new Map<String, Dynamic>();
    try {
      var args = Sys.args();
      if (args.length != 1) {
        throw("Request is missing");
      }
      rq = Json.toMap(B41.decompress(args[0]));
      var page = rq.get(Cgi.PAGE);

      var rp = new Map<String, Dynamic>();
      switch (page) {
        case Cgi.PAGE_CONNECTION: {                         // CONNECTION
          var sessionId = rq.get(Cgi.SESSION_ID);
          var pageId = rq.get(Cgi.PAGE_ID);
          rp.set(Cgi.OK, Cgi.connect(sessionId, pageId));
          Cgi.ok(rp);
        }
        case Cgi.PAGE_AUTHENTICATION: {                     // AUTHENTICATION
          var user = rq.get(Cgi.USER);
          var pass = rq.get(Cgi.PASS);
          var expiration = rq.get(Cgi.EXPIRATION);
          rp.set(Cgi.SESSION_ID, Cgi.authentication(user, pass, expiration));
          Cgi.ok(rp);
        }
        case Cgi.PAGE_CHPASS: {                             // PAGE_CHPASS
          var user = rq.get(Cgi.USER);
          var oldPass = rq.get(Cgi.OLD_PASS);
          var newPass = rq.get(Cgi.PASS);
          reply(rq, function (rq) {
            var rp = new Map();
            rp.set(Cgi.CHPASS_OK, Cgi.changePass(user, oldPass, newPass));
            return rp;
          });
        }
        case "main": reply(rq, PageMain.response);
        case "menu": reply(rq, SMenu.response);
        case "plan": {
          rp.set(Cgi.OK, true);
          Cgi.ok(rp);
        }
        case "settings": reply(rq, PageSettings.response);
        default:                                            // ANYTHING
          throw('Unexpected value "$page" in field "${Cgi.PAGE}"');
      }
    } catch(e:String) {
      var st = haxe.CallStack.toString(haxe.CallStack.exceptionStack());
      Cgi.error(rq, '$e\n$st\n');
    }

    Sys.exit(0);
  }
}
