/*
 * Copyright 20-May-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Application entry
import dm.Ui;
import dm.B41;
import dm.Store;
import dm.I18n;
import dm.CClient;
import lib.Configuration;
import lib.Dom0;
import Authentication;
import Expired;
import By;

/// Entry class
class Main {
  static var executable = "/deme/dmC17/app/hconta/bin/hconta";
  static var appName = "Hconta";
  static var version = "0.0.1";
  static var languageKey = "Hconta__language";
  static var client:CClient = null;

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
          client = c;
          start();
        }
      }
    );
  }

  public static function start() {
    var rq = new Map();
    rq.set(CClient.PAGE, "main");
    client.request(rq, function (rp) {
      var conf:Configuration = {
        client: client,
        language: rp.get("language"),
        page: rp.get("page"),
        subPage: rp.get("subPage")
      }

      var dic = conf.language == "en" ? I18nData.en() : I18nData.es();
      I18n.init(dic);

      switch(conf.page) {
        case "plan" : new Plan(client, conf);
        case "settings" : new Settings(client, conf);
        default : trace("page unknown in Main.start()");
      }
    });
  }
}
