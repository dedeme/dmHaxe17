/*
 * Copyright 05-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Client;
import dm.Server;
import dm.Store;
import dm.I18n;
import dm.It;
import I18nData;

class Global {
  // Store keys
  static var pageStore = "JsDoc__page";
  static var langStore = "JsDoc__lang";

  /// Application name
  public static var app(default, null) = "HDoc";

  /// Tow spaces tabulation
  public static var tab(default, null) = "  ";

  /// Application version
  public static var version(default, null) = "0.0.0";

  /// Page type
  public static var confPage(default, null) = "0";

  /// Page type
  public static var indexPage(default, null) = "1";

  /// Page type
  public static var helpPage(default, null) = "2";

  /// Page type
  public static var codePage(default, null) = "3";

  /// Gets language
  public static function getLanguage():String {
    var r= Store.get(langStore);
    return r == null ? "en" : r;
  }

  /// Sets language
  public static function setLanguage(lang) {
    Store.put(langStore, lang);
    var tx = lang == "en" ? I18nData.en() : I18nData.es();
    I18n.init(tx.split("\n"));
  }

  /// Return a new Client.
  public static function client():Client {
    return new Client(
      app,
      function () { js.Browser.location.assign("../auth/index.html"); },
      function () { js.Browser.location.assign("../auth/index.html"); }
    );
  }

  /// Return a new Server.
  public static function server():Server {
    return new Server(app);
  }
}
