/*
 * Copyright 20-May-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Plan page
import dm.Ui;
import dm.Ui.Q;
import dm.I18n;
import dm.I18n._;
import dm.CClient;
import lib.Model;
import lib.Dom1;

class Settings {
  // Model -----------------------------

  var model:Model;

  // View ------------------------------

  function show() {
    Dom1.show(model, "settings", Q("div").style("text-align:center")
      .add(Q("h2").html(_("Settings")))
      .add(Q("p").html("&nbsp;"))
      .add(Q("p")
        .add(Q("span").html(_("Change language to") + ": "))
        .add(Ui.link(function (ev) {
            lang();
          }).klass("link").html(model.language == "en" ? "ES": "EN")))
      .add(Q("p")
        .add(Ui.link(function (ev) {
            pass();
          }).klass("link").html(_("Change password"))))
    );
  }

  // Control ---------------------------

  public function new(model:Model) {
    this.model = model;

    show();
  }

  function lang() {
    var rq = new Map();
    rq.set(CClient.PAGE, "settings");
    rq.set("setting", "lang");
    model.client.request(rq, function (rp) {
      model.language = model.language == "es" ? "en" : "es";
      Main.start();
    });
  }

  function pass() {
    new Chpass(model.client);
  }
}


