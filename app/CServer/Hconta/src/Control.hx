/*
 * Copyright 10-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.I18n;
import dm.Client;
import view.Chpass;
import view.By;
import view.Diary;
import view.Plan;
import view.Settings;
import model.Action;

class Control {

  public var client(default, null):Client;
  public var model(default, null):Model;

  public function new (client:Client) {
    this.client = client;
    var rq = new Map();
    rq.set(Client.PAGE, "control");
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
      case "diary" : new Diary(this);
      case "cash" : {dm.Ui.alert("Without implementation");new Plan(this);}
      case "plan" : new Plan(this);
      case "settings" : new Settings(this);
      default : trace("page unknown in Control.start()");
    }
  }

  // Sends a request to server and descards its response.
  function request(rq:Map<String, Dynamic>, action:Void->Void) {
    rq.set(Client.PAGE, "control");
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

  /// Changes language
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

  /// Changes password
  public function pass() {
    new Chpass(this);
  }


  // Plan ------------------------------

  function annotate(action:Action) {
    var rq = new Map();
    rq.set("action", "annotate");
    rq.set("year", model.year);
    rq.set("note", Actions.serialize(action));
    request(rq, function () {
      model.processAction(action);
      start();
    });
  }

  /// Changes subpage
  public function planGo(item:String) {
    var rq = new Map();
    rq.set("action", "setConf");
    rq.set("key", "planItem");
    rq.set("value", item);
    request(rq, function () {
      model.planItem = item;
      start();
    });
  }

  /// Adds an entry to plan
  public function planAdd(id:String, name:String, summary:String) {
    var lg = id.length;
    var action = switch (lg) {
      case 2 : AddSubgroup(id, name);
      case 3 : AddAccount(id, name, summary);
      default: AddSubaccount(id, name);
    }
    annotate(action);
  }

  /// Modifies an entry in plan
  public function planMod(id:String, name:String, summary:String) {
    var lg = id.length;
    var action = switch (lg) {
      case 2 : ModSubgroup(id, name);
      case 3 : ModAccount(id, name, summary);
      default: ModSubaccount(id, name);
    }
    annotate(action);
  }

  /// Deletes an entry in plan
  public function planDel(id:String) {
    var lg = id.length;
    var action = switch (lg) {
      case 2 : DelSubgroup(id);
      case 3 : DelAccount(id);
      default: DelSubaccount(id);
    }
    annotate(action);
  }

}

