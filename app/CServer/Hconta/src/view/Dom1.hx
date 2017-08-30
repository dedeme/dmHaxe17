/*
 * Copyright 07-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Internal DOM
package view;

import dm.Client;
import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;
import dm.I18n._;

class Dom1 {
  // Model -----------------------------

  // View ------------------------------

  public static function show(control:Control, page:String, o:DomObject) {
    function entry(id, target) {
      return Ui.link(function (ev) {
          control.go(target);
        }).klass(target == page ? "frame" : "link").html(id);
    }
    function separator() {
      return Q("span").html(" · ");
    }

    var menu = Q("table").klass("main").add(Q("tr")
      .add(Q("td")
        .add(entry(_("Diary"), "diary"))
        .add(separator())
        .add(entry(_("Cash"), "cash"))
        .add(separator())
        .add(entry(_("Plan"), "plan")))
      .add(Q("td").style("text-align:right")
        .add(entry(_("Settings"), "settings"))
        .add(separator())
        .add(Ui.link(function (ev) {
            control.by();
          }).add(Ui.img("cross").style("vertical-align:bottom")))))
    ;

    Dom0.show(
      Q("div")
        .add(menu)
        .add(Q("hr"))
        .add(o)
    );
  }

}
