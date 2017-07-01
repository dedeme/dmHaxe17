/*
 * Copyright 07-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package lib;

import dm.CClient;
import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;
import dm.I18n._;

class Dom1 {
  // Model -----------------------------

  // View ------------------------------

  public static function show(client:CClient, page:String, o:DomObject) {
    function entry(id, target) {
      return Ui.link(function (ev) {
          go(client, target);
        }).klass(target == page ? "frame" : "link").html(id);
    }
    function separator() {
      return Q("span").html(" · ");
    }

    var menu = Q("table").klass("main").add(Q("tr")
      .add(Q("td")
        .add(entry(_("Cash"), "cash"))
        .add(separator())
        .add(entry(_("Plan"), "plan")))
      .add(Q("td").style("text-align:right")
        .add(entry(_("Settings"), "settings"))
        .add(separator())
        .add(Ui.link(function (ev) {
            new By(client);
          }).add(Ui.img("cross").style("vertical-align:bottom")))))
    ;

    Dom0.show(
      Q("div")
        .add(menu)
        .add(Q("hr"))
        .add(o)
    );
  }

  // Control ---------------------------

  static function go(client:CClient, page: String) {
    var rq = new Map();
    rq.set(CClient.PAGE, "menu");
    rq.set("go", page);
    client.request(rq, function (rp) {
      Main.start();
    });
  }

}
