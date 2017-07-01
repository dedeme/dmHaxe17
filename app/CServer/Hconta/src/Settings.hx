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
import lib.Configuration;
import lib.Dom1;

class Settings {
  // Model -----------------------------

  var client:CClient;
  var conf:Configuration;

  // View ------------------------------

  function show() {
    Dom1.show(client, "settings", Q("div").style("text-align:center")
      .add(Q("h2").html(_("Settings")))
      .add(Q("p").html("&nbsp;"))
      .add(Q("p")
        .add(Q("span").html(_("Change language to") + ": "))
        .add(Ui.link(function (ev) {
            lang();
          }).klass("link").html(conf.language == "en" ? "ES": "EN")))
      .add(Q("p")
        .add(Ui.link(function (ev) {
            pass();
          }).klass("link").html(_("Change password"))))
    );
  }

  // Control ---------------------------

  public function new(client, conf) {
    this.client = client;
    this.conf = conf;

    show();
  }

  function lang() {
    var rq = new Map();
    rq.set(CClient.PAGE, "settings");
    rq.set("setting", "lang");
    client.request(rq, function (rp) {
      Main.main();
    });
  }

  function pass() {
    new Chpass(client);
  }
}


