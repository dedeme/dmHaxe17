/*
 * Copyright 20-May-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ui;
import dm.B41;
import dm.Store;
import dm.I18n;
import dm.CClient;
import lib.Model;
import lib.Action;
import lib.Dom0;
import Authentication;
import Expired;
import By;

/// Client entry point
class Main {
  static var executable = "/deme/dmHaxe17/app/CServer/Hconta/server/Hconta";
  static var appName = "Hconta";
  static var version = "0.0.1";
  static var languageKey = "Hconta__language";
  static var model:Model = null;

  /// Entry point
  public static function main() {
    Dom0.appName = appName;
    Dom0.version = version;

    var lang = Store.get(languageKey);
    lang = lang == null ? "en" : lang;
    var dic = lang == "en" ? I18nData.en() : I18nData.es();
    I18n.init(dic);

    CClient.connect(
      executable,
      appName,
      function () {
        new Expired(appName, languageKey);
      },
      function (c) {
        if (c == null) {
          new Authentication(executable, appName, languageKey);
        } else {
          var rq = new Map();
          rq.set(CClient.PAGE, "main");
          c.request(rq, function (rp) {
            model = new Model(c, rp);
            start();
          });
        }
      }
    );
  }

  public static function start() {
    var dic = model.language == "en" ? I18nData.en() : I18nData.es();
    I18n.init(dic);
    switch(model.page) {
      case "plan" : new Plan(model);
      case "settings" : new Settings(model);
      default : trace("page unknown in Main.start()");
    }
  }

}
