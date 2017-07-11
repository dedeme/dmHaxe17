/*
 * Copyright 10-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.I18n;
import dm.CClient;
import view.Chpass;
import view.By;
import view.Plan;
import view.Settings;

class Control {

  public var client(default, null):CClient;
  public var model(default, null):Model;

  public function new (client:CClient) {
    this.client = client;
    var rq = new Map();
    rq.set(CClient.PAGE, "control");
    rq.set("action", "init");
    client.request(rq, function (rp) {
      model = new Model(client, rp);
      start();
    });
  }

  /// Starts pages
  public function start() {
    var dic = model.language == "en" ? I18nData.en() : I18nData.es();
    I18n.init(dic);
    switch(model.page) {
      case "plan" : new Plan(this);
      case "settings" : new Settings(this);
      default : trace("page unknown in Main.start()");
    }
  }

  function request(rq:Map<String, Dynamic>, action:Void->Void) {
    rq.set(CClient.PAGE, "control");
    model.client.request(rq, function (rp) {
      action();
    });
  }

  // menu ------------------------------

  /// Shows 'page'
  public function go(page:String) {
    var rq = new Map();
    rq.set("action", "setConf");
    rq.set("key", "page");
    rq.set("value", page);
    request(rq, function () {
      model.page = page;
      start();
    });
  }

  /// Shows page 'by'
  public function by() {
    new By(this);
  }

  // settings --------------------------
  public function lang() {
    var l = model.language == "es" ? "en" : "es";
    var rq = new Map();
    rq.set("action", "setConf");
    rq.set("key", "language");
    rq.set("value", l);
    request(rq, function () {
      model.language = l;
      start();
    });
  }

  public function pass() {
    new Chpass(this);
  }


  // Server communication --------------



}

