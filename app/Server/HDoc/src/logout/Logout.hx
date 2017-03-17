/*
 * Copyright 09-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ui;
import dm.Ui.Q;
import Dom;
import dm.I18n._;
import dm.I18n;
import Fields;

/// End page.
class Logout {
  ///
  public static function main() {
    var client = Global.client();
    client.send("lib/index.js", "getConf", {}, function (rp:Dynamic) {
      client.close();
      var conf = ConfEntry.restore(rp);
      Global.setLanguage(conf.lang);

      Dom0.show(
        Q("div")
          .add(Q("div").klass("title").html("&nbsp;<br>HDoc<br>&nbsp;"))
          .add(Q("div")
            .add(Q("table")
              .att("class", "border")
              .att("width", "100%")
              .att("style",
                "background-color: #f8f8f8;" +
                "border-collapse: collapse;")
              .add(Q("tr")
                .add(Q("td")
                  .att("style", "padding:0px 10px 0px 10px;")
                  .html(_("Logout-message"))))))
      );
    });
  }
}
