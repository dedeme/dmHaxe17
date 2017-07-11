/*
 * Copyright 20-May-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Settings page
package view;

import dm.Ui;
import dm.Ui.Q;
import dm.I18n;
import dm.I18n._;

class Settings {
  // Model -----------------------------

  var control:Control;

  // View ------------------------------

  function show() {
    var model = control.model;

    Dom1.show(control, "settings", Q("div").style("text-align:center")
      .add(Q("h2").html(_("Settings")))
      .add(Q("p").html("&nbsp;"))
      .add(Q("p")
        .add(Q("span").html(_("Change language to") + ": "))
        .add(Ui.link(function (ev) {
            control.lang();
          }).klass("link").html(model.language == "en" ? "ES": "EN")))
      .add(Q("p")
        .add(Ui.link(function (ev) {
            control.pass();
          }).klass("link").html(_("Change password"))))
    );
  }

  // Control ---------------------------

  public function new(control:Control) {
    this.control = control;

    show();
  }
}


