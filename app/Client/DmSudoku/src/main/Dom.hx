/*
 * Copyright 19-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;

class Dom {
  public static function show(o:DomObject) {
    Ui.QQ("body").next().removeAll().add(
      Q("div")
        .add(o)
        .add(Q("p").html("&nbsp;"))
        .add(Q("hr"))
        .add(Q("table").klass("main")
          .add(Q("tr")
            .add(Q("td")
              .add(Q("a")
                .att("href", "../doc/about.html")
                .att("target", "blank")
                .html("<small>Help & Credits</small>")))
            .add(Q("td")
              .style("text-align: right;font-size: 10px;" +
                "color:#808080;font-size:x-small;")
              .html("- © ºDeme. DmSudoku (" + Main.version + ") -"))))
    );
  }
}
